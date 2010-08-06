Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573Ab0HFSd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:33:26 -0400
Received: from kroah.org ([198.145.64.141]:48527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935476Ab0HFSdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:33:23 -0400
Date: Fri, 6 Aug 2010 11:32:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/38] 2.6.35.1-stable review
Message-ID: <20100806183250.GA23019@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.35.1 release.
There are 38 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by August 8, 2010, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                       |    2 +-
 arch/arm/plat-mxc/gpio.c                       |    8 ++
 arch/arm/plat-mxc/include/mach/gpio.h          |    1 +
 arch/parisc/kernel/firmware.c                  |   12 +--
 arch/x86/xen/enlighten.c                       |    2 +-
 arch/x86/xen/time.c                            |   39 -------
 drivers/edac/amd64_edac.c                      |    6 +-
 drivers/gpu/drm/i915/intel_display.c           |  144 +++++++++++++++---------
 drivers/gpu/drm/i915/intel_drv.h               |    8 +-
 drivers/gpu/drm/i915/intel_overlay.c           |    7 +-
 drivers/gpu/drm/radeon/r600.c                  |   24 ++++-
 drivers/gpu/drm/radeon/r600d.h                 |    1 +
 drivers/gpu/drm/radeon/radeon_object.c         |   27 +++--
 drivers/gpu/drm/radeon/rs690.c                 |   27 ++---
 drivers/gpu/drm/radeon/rv515.c                 |   23 ++---
 drivers/gpu/drm/radeon/rv770.c                 |    5 +-
 drivers/gpu/drm/radeon/rv770d.h                |    1 +
 drivers/misc/enclosure.c                       |    7 +-
 drivers/net/e1000e/hw.h                        |    2 +-
 drivers/net/e1000e/netdev.c                    |   13 ++-
 drivers/net/igb/igb_main.c                     |    8 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c  |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    6 +-
 drivers/net/wireless/ath/ath9k/hw.c            |   23 +++-
 drivers/net/wireless/ath/ath9k/xmit.c          |   95 ++++++++++------
 drivers/net/wireless/iwlwifi/iwl-scan.c        |   18 ++--
 drivers/net/xen-netfront.c                     |    1 +
 drivers/parisc/led.c                           |    6 +-
 drivers/ssb/driver_chipcommon.c                |    1 +
 drivers/ssb/pci.c                              |   15 ++-
 fs/block_dev.c                                 |    4 +-
 include/drm/drm_pciids.h                       |    7 +
 include/linux/netdevice.h                      |    2 +
 include/linux/notifier.h                       |    1 +
 kernel/signal.c                                |    9 +-
 net/9p/trans_fd.c                              |    2 +-
 net/ipv4/devinet.c                             |    1 +
 net/mac80211/mesh_plink.c                      |   42 +++++--
 net/sched/sch_generic.c                        |   18 +++
 net/wireless/mlme.c                            |    8 +-
 net/wireless/scan.c                            |    5 +
 45 files changed, 395 insertions(+), 250 deletions(-)

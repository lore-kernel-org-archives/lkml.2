Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633Ab0HFT2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:28:17 -0400
Received: from kroah.org ([198.145.64.141]:43487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871Ab0HFT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:27:53 -0400
Date: Fri, 6 Aug 2010 12:26:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/36] 2.6.34.3-stable review
Message-ID: <20100806192649.GA1614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.34.3 release.
There are 36 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by August 8, 2010, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.34.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    2 +-
 arch/arm/plat-mxc/gpio.c                    |    8 +++
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 +
 arch/parisc/kernel/firmware.c               |   12 +----
 arch/x86/kvm/mmu.c                          |    2 +
 arch/x86/xen/enlighten.c                    |    2 +-
 arch/x86/xen/time.c                         |   39 ---------------
 drivers/edac/amd64_edac.c                   |    6 +-
 drivers/gpu/drm/i915/intel_overlay.c        |    7 ++-
 drivers/gpu/drm/radeon/r600.c               |   24 +++++++++-
 drivers/gpu/drm/radeon/r600d.h              |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |   15 ++----
 drivers/gpu/drm/radeon/radeon_combios.c     |    4 ++
 drivers/gpu/drm/radeon/rs600.c              |    1 -
 drivers/gpu/drm/radeon/rs690.c              |    2 +-
 drivers/gpu/drm/radeon/rv770.c              |    5 ++-
 drivers/gpu/drm/radeon/rv770d.h             |    1 +
 drivers/misc/enclosure.c                    |    7 ++-
 drivers/net/e1000e/hw.h                     |    2 +-
 drivers/net/e1000e/netdev.c                 |   13 ++++--
 drivers/net/igb/igb_main.c                  |    8 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c         |   19 ++++++-
 drivers/net/wireless/ath/ath9k/xmit.c       |   68 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   18 +++----
 drivers/parisc/led.c                        |    6 ++-
 drivers/ssb/driver_chipcommon_pmu.c         |   17 ++++---
 drivers/ssb/pci.c                           |   20 ++------
 drivers/staging/comedi/Kconfig              |    5 ++
 drivers/staging/comedi/drivers/Makefile     |    4 +-
 fs/gfs2/dir.c                               |    2 +-
 fs/nfs/file.c                               |   13 ++++-
 fs/nfs/write.c                              |    7 +--
 include/drm/drm_pciids.h                    |    7 +++
 include/linux/nfs_fs.h                      |    7 +++
 include/linux/ssb/ssb.h                     |    5 ++-
 include/linux/ssb/ssb_driver_chipcommon.h   |   15 ++++++-
 mm/memory.c                                 |   16 +++++-
 net/9p/trans_fd.c                           |    2 +-
 net/mac80211/mesh_plink.c                   |   42 ++++++++++++----
 net/wireless/mlme.c                         |    8 ++--
 net/wireless/scan.c                         |    5 ++
 42 files changed, 265 insertions(+), 185 deletions(-)

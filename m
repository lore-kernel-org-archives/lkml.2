Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab1EFA5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:57:10 -0400
Received: from kroah.org ([198.145.64.141]:55560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1EFA5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:57:06 -0400
Date: Thu, 5 May 2011 17:26:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/43] 2.6.33.13-longterm review
Message-ID: <20110506002625.GA20426@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.13 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, May 8, 2011, 00:01:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.13-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                |    2 +-
 arch/arm/kernel/sys_oabi-compat.c       |    2 +-
 arch/m68k/mm/motorola.c                 |    2 ++
 arch/parisc/mm/init.c                   |    4 +++-
 arch/x86/kernel/cpu/amd.c               |    2 +-
 arch/x86/kernel/pci-gart_64.c           |    9 ++++++++-
 block/blk-sysfs.c                       |    4 +++-
 drivers/ata/libata-scsi.c               |   24 ++++++++++++++++++------
 drivers/char/agp/generic.c              |   19 +++++++++++++++----
 drivers/char/i8k.c                      |    7 ++++---
 drivers/gpu/drm/radeon/atom.c           |    6 +++---
 drivers/input/xen-kbdfront.c            |   12 +++++++++++-
 drivers/media/dvb/b2c2/flexcop-pci.c    |    2 +-
 drivers/mmc/host/sdhci-pci.c            |    1 +
 drivers/mmc/host/sdhci.c                |    9 ++++++++-
 drivers/net/igbvf/igbvf.h               |    1 -
 drivers/net/wireless/ath/regd_common.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    8 ++++++--
 drivers/net/wireless/p54/txrx.c         |    2 +-
 drivers/pci/intel-iommu.c               |   15 +++++++++++++--
 drivers/s390/block/dasd_eckd.c          |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c      |   23 +++++++++++++++++++++--
 drivers/scsi/pmcraid.c                  |    3 +++
 drivers/scsi/scsi_sysfs.c               |   16 ++++++++--------
 drivers/serial/imx.c                    |    3 ++-
 drivers/staging/usbip/vhci_hcd.c        |    2 +-
 drivers/usb/musb/musb_core.c            |    1 +
 fs/nfs/inode.c                          |   26 +++++++++++++++++---------
 fs/nfs/nfs4state.c                      |    4 ++--
 fs/nfs/super.c                          |    9 +++++++++
 fs/nfsd/vfs.c                           |    9 ++++++++-
 fs/partitions/ldm.c                     |   16 ++++++++++++----
 fs/ubifs/recovery.c                     |   26 ++++++++++++++++++++++++++
 init/Kconfig                            |    1 +
 net/can/bcm.c                           |    7 ++++++-
 net/ipv4/ip_output.c                    |    9 ++++++---
 net/unix/af_unix.c                      |   16 +++++++++++++++-
 scripts/kconfig/conf.c                  |    2 +-
 sound/soc/codecs/wm_hubs.c              |    8 ++++----
 40 files changed, 246 insertions(+), 71 deletions(-)

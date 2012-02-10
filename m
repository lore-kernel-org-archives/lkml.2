Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab2BJWhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:37:03 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62978 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373Ab2BJWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:36:50 -0500
Date: Fri, 10 Feb 2012 14:35:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [patch 00/86] 3.2.6-stable review
Message-ID: <20120210223514.GA24190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#include <stable/formletter.h>
#define RELEASE         3.2.6-rc1
#define NUM_PATCHES     86
#define RESPONSE_DATE   "Mon Feb 13 22:00:00 UTC 2012"
#define LOCATION        kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.6-rc1.gz

diffstat below.

greg k-h

 Makefile                                  |    4 +-
 arch/arm/kernel/ptrace.c                  |    8 +-
 arch/arm/kernel/signal.c                  |    5 +-
 arch/arm/mach-omap2/gpmc.c                |    6 ++
 drivers/cpufreq/powernow-k8.c             |   30 ++++---
 drivers/dma/at_hdmac.c                    |    4 +-
 drivers/dma/at_hdmac_regs.h               |   17 ++--
 drivers/firewire/ohci.c                   |    6 +-
 drivers/gpu/drm/i915/i915_debugfs.c       |    8 ++-
 drivers/gpu/drm/i915/i915_dma.c           |    1 +
 drivers/gpu/drm/i915/i915_drv.c           |   20 +++--
 drivers/gpu/drm/i915/i915_drv.h           |   12 ++-
 drivers/gpu/drm/i915/i915_irq.c           |   13 ++-
 drivers/gpu/drm/i915/i915_suspend.c       |    4 +
 drivers/gpu/drm/i915/intel_dp.c           |    1 +
 drivers/gpu/drm/i915/intel_hdmi.c         |    8 ++-
 drivers/gpu/drm/i915/intel_tv.c           |   16 ++--
 drivers/gpu/drm/nouveau/nouveau_gem.c     |   23 +++++-
 drivers/gpu/drm/radeon/atombios_crtc.c    |    4 +-
 drivers/gpu/drm/radeon/atombios_dp.c      |   18 ++++-
 drivers/gpu/drm/radeon/radeon_device.c    |    4 +
 drivers/hwmon/w83627ehf.c                 |   23 +++++-
 drivers/infiniband/core/uverbs_cmd.c      |    1 +
 drivers/infiniband/core/verbs.c           |    2 +-
 drivers/infiniband/hw/mlx4/mad.c          |    7 +-
 drivers/iommu/amd_iommu.c                 |    3 +
 drivers/iommu/msm_iommu.c                 |    7 +--
 drivers/misc/cb710/core.c                 |    1 +
 drivers/mtd/nand/atmel_nand.c             |   45 +++++++++-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c     |   18 +++-
 drivers/net/ethernet/realtek/8139cp.c     |    1 +
 drivers/pcmcia/ds.c                       |    4 +-
 drivers/staging/asus_oled/asus_oled.c     |   13 ++-
 drivers/staging/rtl8712/drv_types.h       |    7 ++
 drivers/staging/rtl8712/hal_init.c        |   62 ++++++++++----
 drivers/staging/rtl8712/os_intfs.c        |   14 +++-
 drivers/staging/rtl8712/rtl8712_hal.h     |    1 +
 drivers/staging/rtl8712/usb_intf.c        |   10 ++-
 drivers/staging/zcache/zcache-main.c      |   11 +--
 drivers/target/iscsi/iscsi_target.c       |   39 ++++++++-
 drivers/target/iscsi/iscsi_target_core.h  |    2 +
 drivers/target/iscsi/iscsi_target_login.c |   31 ++++++-
 drivers/target/iscsi/iscsi_target_util.c  |   11 +++
 drivers/target/target_core_cdb.c          |    9 ++-
 drivers/target/target_core_pr.c           |    5 +-
 drivers/target/target_core_transport.c    |   21 ++++-
 drivers/tty/vt/vt_ioctl.c                 |    1 -
 drivers/usb/gadget/f_loopback.c           |    2 +-
 drivers/usb/host/pci-quirks.c             |    6 ++
 drivers/usb/serial/ftdi_sio.c             |    1 +
 drivers/usb/serial/ftdi_sio_ids.h         |    7 ++
 drivers/usb/serial/option.c               |  129 ++++++++++++++++++++++++++++-
 drivers/video/atmel_lcdfb.c               |    2 +-
 fs/cifs/sess.c                            |    7 +-
 fs/ecryptfs/read_write.c                  |    4 +-
 fs/proc/base.c                            |  106 ++++++++++-------------
 fs/udf/super.c                            |    6 ++
 include/linux/freezer.h                   |    2 +
 include/linux/pm_qos.h                    |   14 +++-
 include/linux/usb/ch9.h                   |    2 +-
 kernel/kprobes.c                          |    6 +-
 kernel/panic.c                            |   17 +++-
 kernel/power/hibernate.c                  |    2 +-
 kernel/power/power.h                      |    2 +
 kernel/power/process.c                    |    9 ++
 kernel/power/user.c                       |   22 ++++-
 kernel/sched_rt.c                         |    5 +
 mm/compaction.c                           |   24 +++++-
 mm/filemap.c                              |    8 +-
 mm/filemap_xip.c                          |    7 ++-
 mm/huge_memory.c                          |    4 +-
 mm/swap.c                                 |    2 +-
 sound/pci/hda/hda_codec.c                 |    2 +-
 sound/pci/hda/patch_cirrus.c              |    6 +-
 sound/pci/hda/patch_realtek.c             |   44 ++++++++--
 sound/pci/hda/patch_via.c                 |   28 +++++--
 sound/pci/oxygen/oxygen_mixer.c           |   25 +++---
 sound/soc/codecs/wm8962.c                 |    6 +-
 sound/soc/codecs/wm8994.c                 |    6 +-
 sound/soc/codecs/wm_hubs.c                |   18 +++--
 80 files changed, 823 insertions(+), 269 deletions(-)


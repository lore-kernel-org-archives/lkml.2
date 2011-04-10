Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab1DJVbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:31:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4621 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab1DJVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:31:36 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] staging: Remove unnecessary semicolons
Date: Sun, 10 Apr 2011 14:31:31 -0700
Message-Id: <cover.1302470807.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (4):
  staging: Remove unnecessary semicolons when if (foo) {...};
  staging: Remove unnecessary semicolons when while (foo) {...};
  staging: Remove unnecessary semicolons when for (foo) {...};
  staging: Remove unnecessary semicolons when switch (foo) {...};

 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    6 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    4 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    6 +-
 drivers/staging/comedi/drivers/ni_tio.c            |    6 +-
 drivers/staging/comedi/drivers/pcl724.c            |    2 +-
 drivers/staging/comedi/drivers/pcl818.c            |    2 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    2 +-
 drivers/staging/crystalhd/crystalhd_misc.c         |    4 +-
 drivers/staging/cx25821/cx25821-video.c            |    2 +-
 drivers/staging/hv/hv_util.c                       |    2 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |    2 +-
 drivers/staging/iio/addac/adt7316.c                |    6 +-
 drivers/staging/intel_sst/intel_sst_pvt.c          |    2 +-
 drivers/staging/lirc/lirc_serial.c                 |    2 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    2 +-
 drivers/staging/vt6655/bssdb.c                     |    8 ++--
 drivers/staging/vt6655/device_main.c               |   14 +++---
 drivers/staging/vt6655/dpc.c                       |   10 ++--
 drivers/staging/vt6655/ioctl.c                     |   44 +++++++++---------
 drivers/staging/vt6655/power.c                     |    2 +-
 drivers/staging/vt6655/rxtx.c                      |    4 +-
 drivers/staging/vt6655/wcmd.c                      |   14 +++---
 drivers/staging/vt6655/wmgr.c                      |   46 +++++++++---------
 drivers/staging/vt6655/wpactl.c                    |   10 ++--
 drivers/staging/vt6656/bssdb.c                     |    8 ++--
 drivers/staging/vt6656/dpc.c                       |   10 ++--
 drivers/staging/vt6656/ioctl.c                     |   44 +++++++++---------
 drivers/staging/vt6656/main_usb.c                  |    4 +-
 drivers/staging/vt6656/rxtx.c                      |    4 +-
 drivers/staging/vt6656/wcmd.c                      |    8 ++--
 drivers/staging/vt6656/wmgr.c                      |   48 ++++++++++----------
 drivers/staging/vt6656/wpactl.c                    |   10 ++--
 .../arch/arm/mach-omap2/cyashalomap_kernel.c       |    2 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 37 files changed, 174 insertions(+), 174 deletions(-)

-- 
1.7.4.2.g597a6.dirty


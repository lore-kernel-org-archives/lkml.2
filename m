Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab0LCLmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:42:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33785 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab0LCLmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:42:40 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC v6 0/9] FM V4L2 drivers for WL128x
Date: Fri,  3 Dec 2010 07:50:22 -0500
Message-Id: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Mauro and the list,

This is the v6 version of the TI WL128x FM V4L2 drivers patchset.
Texas Instrument's WL128x chipset packs BT, FM, GPS and WLAN in a single
die with BT, FM and GPS being interfaced over a single UART.
This driver works on top of the shared transport line discipline driver.
This driver can also be made use for the WL127x version of the chip which packs
BT, FM and WLAN only.

Comments on the last version of the patches have been taken care,
such asi
- Removed use of new V4L2 CID to set the BAND (US/JAPAN). Instead handle it
in driver.
- Removed the new private CID defined for channel spacing instead handle it
in ioctl VIDIOC_S_HW_FREQ_SEEK.

Also,
Can you please also stage this version? Since the files are becoming big
to be posted as patches?

Thanks & Regards,
Manjunatha Halli

Manjunatha Halli (9):
  include:linux: videodev2.h: FM Rx control class
  Documentation:DocBook:v4l: Update the controls.xml for TI FM driver
  drivers:staging: ti-st: fmdrv common header file
  drivers:staging: ti-st: fmdrv_v4l2 sources
  drivers:staging: ti-st: fmdrv_common sources
  drivers:staging: ti-st: FM driver RX sources
  drivers:staging: ti-st: FM driver TX sources
  drivers:staging: ti-st: Kconfig & Makefile change
  driver:staging:ti-st: Update TODO for FM V4L2 driver.

 Documentation/DocBook/v4l/controls.xml |   12 +
 drivers/staging/ti-st/Kconfig          |   10 +
 drivers/staging/ti-st/Makefile         |    2 +
 drivers/staging/ti-st/TODO             |   10 +-
 drivers/staging/ti-st/fmdrv.h          |  239 ++++
 drivers/staging/ti-st/fmdrv_common.c   | 2003 ++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h   |  402 +++++++
 drivers/staging/ti-st/fmdrv_rx.c       |  902 ++++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h       |   59 +
 drivers/staging/ti-st/fmdrv_tx.c       |  420 +++++++
 drivers/staging/ti-st/fmdrv_tx.h       |   37 +
 drivers/staging/ti-st/fmdrv_v4l2.c     |  720 ++++++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h     |   32 +
 include/linux/videodev2.h              |    8 +
 14 files changed, 4855 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0K2NKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:10:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34972 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0K2NKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:10:12 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC v5 0/9] FM V4L2 drivers for WL128x
Date: Mon, 29 Nov 2010 09:18:34 -0500
Message-Id: <1291040323-2641-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Mauro and the list,

This is the v5 version of the TI WL128x FM V4L2 drivers patchset.
Texas Instrument's WL128x chipset packs BT, FM, GPS and WLAN in a single
die with BT, FM and GPS being interfaced over a single UART.
This driver works on top of the shared transport line discipline driver.
This driver can also be made use for the WL127x version of the chip which packs
BT, FM and WLAN only.

Comments on the last version of the patches have been taken care,
such as
- Removed the array for opcode handling, instead defined them as macro's.
- Moved the error message to fmc_senc_cmd() instead of printing it from all
the caller functions.
- Use of 'cpu_to_be16' macro instead of using custom macro.

Also,
Can you please also stage this version? Since the files are becoming big
to be posted as patches?

Thanks & Regards,
Manjunatha.


Manjunatha Halli (9):
  include:linux: videodev2.h: FM Rx control class
  Documentation:DocBook:v4l: Update the controls.xml for TI FM driver
  drivers:staging: ti-st: fmdrv common header file
  drivers:staging: ti-st: fmdrv_v4l2 sources
  drivers:staging: ti-st: fmdrv_common sources
  drivers:staging: ti-st: fmdrv_rx sources
  drivers:staging: ti-st: fmdrv_tx sources
  drivers:staging: ti-st: Kconfig & Makefile change
  driver:staging:ti-st: Update TODO for FM V4L2 driver.

 Documentation/DocBook/v4l/controls.xml |   12 +
 drivers/staging/ti-st/Kconfig          |   10 +
 drivers/staging/ti-st/Makefile         |    2 +
 drivers/staging/ti-st/TODO             |   17 +-
 drivers/staging/ti-st/fmdrv.h          |  247 ++++
 drivers/staging/ti-st/fmdrv_common.c   | 2005 ++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h   |  412 +++++++
 drivers/staging/ti-st/fmdrv_rx.c       |  903 ++++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h       |   59 +
 drivers/staging/ti-st/fmdrv_tx.c       |  420 +++++++
 drivers/staging/ti-st/fmdrv_tx.h       |   37 +
 drivers/staging/ti-st/fmdrv_v4l2.c     |  755 ++++++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h     |   32 +
 include/linux/videodev2.h              |    8 +
 14 files changed, 4918 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h


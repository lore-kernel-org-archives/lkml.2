Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab0KPM4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:56:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49306 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab0KPM4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:56:50 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [PATCH v4 0/6] FM V4L2 drivers for WL128x
Date: Tue, 16 Nov 2010 08:18:08 -0500
Message-Id: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Mauro, Hans and the list,

This is the v4 version of the TI WL128x FM V4L2 drivers patchset.
Texas Instrument's WL128x chipset packs BT, FM, GPS and WLAN in a single
die with BT, FM and GPS being interfaced over a single UART.
This driver works on top of the shared transport line discipline driver.
This driver can also be made use for the WL127x version of the chip which packs
BT, FM and WLAN only.

Comments on the last version of the patches have been taken care,
such as
- New private CID for Channel Spacing added.
- FM Seek Wrap around support is also added.
- Few other style issues also taken care of.

Also,
Can you please also stage this version? Since the files are becoming big
to be posted as patches?
Currently there are few modifications which are supposed to go into videodev2.h
which have been added to generic header file to make it self-contained.

Thanks & Regards,
Manjunatha.

Manjunatha Halli (6):
  drivers:staging: ti-st: fmdrv common header file
  drivers:staging: ti-st: fmdrv_v4l2 sources
  drivers:staging: ti-st: fmdrv_common sources
  drivers:staging: ti-st: fmdrv_rx sources
  drivers:staging: ti-st: fmdrv_tx sources
  drivers:staging: ti-st: Kconfig & Makefile change

 drivers/staging/ti-st/Kconfig        |   10 +
 drivers/staging/ti-st/Makefile       |    2 +
 drivers/staging/ti-st/fmdrv.h        |  259 ++++
 drivers/staging/ti-st/fmdrv_common.c | 2141 ++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h |  458 ++++++++
 drivers/staging/ti-st/fmdrv_rx.c     |  979 ++++++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h     |   59 +
 drivers/staging/ti-st/fmdrv_tx.c     |  461 ++++++++
 drivers/staging/ti-st/fmdrv_tx.h     |   37 +
 drivers/staging/ti-st/fmdrv_v4l2.c   |  757 ++++++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
 11 files changed, 5195 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h


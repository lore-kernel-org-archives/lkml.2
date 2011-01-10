Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1AJMlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:41:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35085 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1AJMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:41:10 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC V9 0/7] FM V4L2 drivers for WL128x
Date: Mon, 10 Jan 2011 08:04:53 -0500
Message-Id: <1294664700-26949-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Mauro and the list,

This is the v9 version of the TI WL128x FM V4L2 drivers patchset.
This introduces wl128x folder under the drivers/media/radio which cater
to FM core on Texas Instrument's WL128x (also compatible with WL127x)
WiLink chipsets.
WL128x's FM can work in either Rx or Tx mode, and V4L2 interfaces are
provided for both.

** patch description **

Texas Instrument's WL128x chipset packs BT, FM, GPS and WLAN in a single
die with BT, FM and GPS being interfaced over a single UART.
This driver works on top of the shared transport line discipline driver.
This driver can also be made use for the WL127x version of the chip which
packs BT, FM and WLAN only.

Comments on the last version of the patches have been taken care,
such as,
- using the 'early return' constructs where applicable.
- Renaming all the variables based on scope and frequency of use.
- Use of 'temp' pointers wherever required insted of breaking the lines.
- printing the error messages at the lowest level,and just propagate the
error code up without repeating the error message.

Thanks & Regards,
Manjunatha Halli


Manjunatha Halli (7):
  drivers:media:radio: wl128x: fmdrv common header file
  drivers:media:radio: wl128x: FM Driver V4L2 sources
  drivers:media:radio: wl128x: FM Driver Common  sources
  drivers:media:radio: wl128x: FM driver RX sources
  drivers:media:radio: wl128x: FM driver TX sources
  drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
  drivers:media:radio: Update Kconfig and Makefile for wl128x FM
    driver.

 drivers/media/radio/Kconfig               |    3 +
 drivers/media/radio/Makefile              |    1 +
 drivers/media/radio/wl128x/Kconfig        |   17 +
 drivers/media/radio/wl128x/Makefile       |    6 +
 drivers/media/radio/wl128x/fmdrv.h        |  242 ++++
 drivers/media/radio/wl128x/fmdrv_common.c | 1693 +++++++++++++++++++++++++++++
 drivers/media/radio/wl128x/fmdrv_common.h |  402 +++++++
 drivers/media/radio/wl128x/fmdrv_rx.c     |  876 +++++++++++++++
 drivers/media/radio/wl128x/fmdrv_rx.h     |   59 +
 drivers/media/radio/wl128x/fmdrv_tx.c     |  433 ++++++++
 drivers/media/radio/wl128x/fmdrv_tx.h     |   37 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c   |  594 ++++++++++
 drivers/media/radio/wl128x/fmdrv_v4l2.h   |   33 +
 13 files changed, 4396 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/wl128x/Kconfig
 create mode 100644 drivers/media/radio/wl128x/Makefile
 create mode 100644 drivers/media/radio/wl128x/fmdrv.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h


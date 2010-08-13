Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420Ab0HMN42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:56:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60887 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934294Ab0HMN4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:56:22 -0400
From: raja_mani@ti.com
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, pavan_savoy@sify.com, Raja-Mani <x0102026@ti.com>
Subject: [PATCH/RFC 0/6] FM V4L2 driver for WL128x
Date: Fri, 13 Aug 2010 10:14:38 -0400
Message-Id: <1281708884-15462-1-git-send-email-raja_mani@ti.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja-Mani <x0102026@ti.com>

The following patches are FM V4L2-Radio drivers for WL128x
(backward compatible for WL127x). TI's V4L2 based FM driver 
uses APIs and header files of TI's Shared Transport driver 
that is hosted in "staging/ti-st/" folder.

I request to add TI FM driver to "staging/ti-st/" folder. 
This will help us keep track of changes to TI FM driver.

V4L2 maintainers are fine to review TI FM driver from staging folder. 
Details of discussion can be found at 
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/20918

Only FM Rx is supported as of now. Any FM V4L2 Radio standard application
can make use of the '/dev/radioX' interface exposed by this driver to
communicate with the TI FM chip.

This has support for RDS, FM firmware download, HW Seek, Tune, 
Volume control,etc. 

Raja-Mani (6):
  drivers:staging:ti-st: sources for FM common interfaces
  drivers:staging:ti-st: Sources for FM RX
  drivers:staging:ti-st: Sources for FM common header
  drivers:staging:ti-st: Sources for FM V4L2 interfaces
  Staging: ti-st: update Kconfig and Makefile for FM driver
  Staging: ti-st: Add TODO file for FM

 drivers/staging/ti-st/Kconfig        |    8 +
 drivers/staging/ti-st/Makefile       |    2 +
 drivers/staging/ti-st/fm_TODO        |   16 +
 drivers/staging/ti-st/fmdrv.h        |  225 ++++
 drivers/staging/ti-st/fmdrv_common.c | 2127 ++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h |  459 ++++++++
 drivers/staging/ti-st/fmdrv_rx.c     |  805 +++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h     |   56 +
 drivers/staging/ti-st/fmdrv_v4l2.c   |  552 +++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h   |   32 +
 10 files changed, 4282 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fm_TODO
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h


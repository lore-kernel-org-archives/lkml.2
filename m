Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0IVKhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:37:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41872 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0IVKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:37:45 -0400
From: x0130808@ti.com
To: linux-kernel@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>
Subject: [RFC/PATCH 0/9] V4L2 FM driver for TI WL127x and WL128x
Date: Wed, 22 Sep 2010 07:48:30 -0400
Message-Id: <1285156119-28531-1-git-send-email-x0130808@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja Mani <raja_mani@ti.com>

This is third patch set for TI FM driver for TI WiLink chips.
It provides FM Receive and Transmit support for TI WL127x and WL128x chips.
It also extends V4L2 CIDs to support few FM Receive features.

Note:
This patch set re-uses new FM RX CID definitions by Nokia FM driver for
TI WL127x chip. Recent Nokia patch can be found at
http://www.spinics.net/lists/linux-media/msg22484.html.

TI FM driver makes use of TI Shared Transport solution for TI WL chips.
TI Shared Transport driver is available in mainline kernel staging
folder - /drivers/staging/ti-st/.

Raja Mani (9):
  drivers:staging:ti-st: sources for FM common interfaces
  drivers:staging:ti-st: Sources for FM RX
  drivers:staging:ti-st: Sources for FM TX
  drivers:staging:ti-st: Sources for FM V4L2 interfaces
  drivers:staging:ti-st: Sources for FM common header
  drivers:media:video: Adding new CIDs for FM RX ctls
  include:linux:videodev2: Define 2 new CIDs for FM RX ctls
  Documentation:DocBook:v4l: Update the controls.xml for FM driver
  Staging:ti-st: Update Kconfig and Makefile for FM driver

 Documentation/DocBook/v4l/controls.xml |   12 +
 drivers/media/video/v4l2-common.c      |    4 +
 drivers/staging/ti-st/Makefile         |    2 +-
 drivers/staging/ti-st/fm.h             |   13 +
 drivers/staging/ti-st/fmdrv.h          |  230 ++++
 drivers/staging/ti-st/fmdrv_common.c   | 2149 ++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/fmdrv_common.h   |  476 +++++++
 drivers/staging/ti-st/fmdrv_rx.c       |  927 ++++++++++++++
 drivers/staging/ti-st/fmdrv_rx.h       |   57 +
 drivers/staging/ti-st/fmdrv_tx.c       |  451 +++++++
 drivers/staging/ti-st/fmdrv_tx.h       |   37 +
 drivers/staging/ti-st/fmdrv_v4l2.c     |  731 +++++++++++
 drivers/staging/ti-st/fmdrv_v4l2.h     |   32 +
 include/linux/videodev2.h              |    7 +
 14 files changed, 5127 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/ti-st/fm.h
 create mode 100644 drivers/staging/ti-st/fmdrv.h
 create mode 100644 drivers/staging/ti-st/fmdrv_common.c
 create mode 100644 drivers/staging/ti-st/fmdrv_common.h
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_rx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
 create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
 create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h


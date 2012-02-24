Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2BXUOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:14:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35834 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab2BXUOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:14:33 -0500
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <shahed@ti.com>, <linux-kernel@vger.kernel.org>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH 0/3] [media] wl128x: Fixes and few new features
Date: Fri, 24 Feb 2012 14:14:28 -0600
Message-ID: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

Mauro and the list,

This patch set Fix build errors when GPIOLIB is not enabled.

Also this patch adds few new features to TI's FM driver fetures
are listed below,

	1) FM TX RDS Support (RT, PS, AF, PI, PTY)
	2) FM RX Russian band support
	3) FM RX AF set/get
	4) FM RX De-emphasis mode set/get

Along with new features this patch also fixes few issues in the driver
like default rssi level for seek, unnecessory logs etc.

Manjunatha Halli (2):
  wl128x: Add support for FM TX RDS
  wl128x: Add sysfs based support for FM features

Randy Dunlap (1):
  wl128x: Fix build errors when GPIOLIB is not enabled.

 drivers/media/radio/wl128x/Kconfig        |    4 +-
 drivers/media/radio/wl128x/fmdrv.h        |    1 +
 drivers/media/radio/wl128x/fmdrv_common.c |   28 +++-
 drivers/media/radio/wl128x/fmdrv_common.h |   41 +++--
 drivers/media/radio/wl128x/fmdrv_rx.c     |   15 ++-
 drivers/media/radio/wl128x/fmdrv_tx.c     |   47 +++----
 drivers/media/radio/wl128x/fmdrv_tx.h     |    3 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c   |  235 ++++++++++++++++++++++++++++-
 8 files changed, 316 insertions(+), 58 deletions(-)

-- 
1.7.4.1


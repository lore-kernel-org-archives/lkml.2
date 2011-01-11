Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1AKLHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:07:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52621 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab1AKLHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:07:35 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC V10 6/7] drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
Date: Tue, 11 Jan 2011 06:31:26 -0500
Message-Id: <1294745487-29138-7-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1294745487-29138-6-git-send-email-manjunatha_halli@ti.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-5-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-6-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/wl128x/Kconfig  |   17 +++++++++++++++++
 drivers/media/radio/wl128x/Makefile |    6 ++++++
 2 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/wl128x/Kconfig
 create mode 100644 drivers/media/radio/wl128x/Makefile

diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
new file mode 100644
index 0000000..749f67b
--- /dev/null
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -0,0 +1,17 @@
+#
+# TI's wl128x FM driver based on TI's ST driver.
+#
+menu "Texas Instruments WL128x FM driver (ST based)"
+config RADIO_WL128X
+	tristate "Texas Instruments WL128x FM Radio"
+	depends on VIDEO_V4L2 && RFKILL
+	select TI_ST
+	help
+	Choose Y here if you have this FM radio chip.
+
+	In order to control your radio card, you will need to use programs
+	that are compatible with the Video For Linux 2 API.  Information on
+	this API and pointers to "v4l2" programs may be found at
+	<file:Documentation/video4linux/API.html>.
+
+endmenu
diff --git a/drivers/media/radio/wl128x/Makefile b/drivers/media/radio/wl128x/Makefile
new file mode 100644
index 0000000..32a0ead
--- /dev/null
+++ b/drivers/media/radio/wl128x/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for TI's shared transport driver based wl128x
+# FM radio.
+#
+obj-$(CONFIG_RADIO_WL128X)	+= fm_drv.o
+fm_drv-objs		:= fmdrv_common.o fmdrv_rx.o fmdrv_tx.o fmdrv_v4l2.o
-- 
1.5.6.3


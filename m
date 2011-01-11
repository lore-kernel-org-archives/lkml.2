Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1AKLJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:09:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52619 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab1AKLHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:07:34 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC V10 7/7] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver.
Date: Tue, 11 Jan 2011 06:31:27 -0500
Message-Id: <1294745487-29138-8-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1294745487-29138-7-git-send-email-manjunatha_halli@ti.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-5-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-6-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-7-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/Kconfig  |    3 +++
 drivers/media/radio/Makefile |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..4529bc7 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -452,4 +452,7 @@ config RADIO_TIMBERDALE
 	  found behind the Timberdale FPGA on the Russellville board.
 	  Enabling this driver will automatically select the DSP and tuner.
 
+# TI's ST based wl128x FM radio
+source "drivers/media/radio/wl128x/Kconfig"
+
 endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index f615583..b71f448 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
 obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
 obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
+obj-$(CONFIG_RADIO_WL128X) += wl128x/
 
 EXTRA_CFLAGS += -Isound
-- 
1.5.6.3


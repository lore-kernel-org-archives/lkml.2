Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab0HMN5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:57:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43382 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396Ab0HMN4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:56:25 -0400
From: raja_mani@ti.com
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, pavan_savoy@sify.com, Raja-Mani <x0102026@ti.com>,
        Pramodh AG <pramodh_ag@ti.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH/RFC 5/6] Staging: ti-st: update Kconfig and Makefile for FM driver
Date: Fri, 13 Aug 2010 10:14:43 -0400
Message-Id: <1281708884-15462-6-git-send-email-raja_mani@ti.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1281708884-15462-5-git-send-email-raja_mani@ti.com>
References: <1281708884-15462-1-git-send-email-raja_mani@ti.com>
 <1281708884-15462-2-git-send-email-raja_mani@ti.com>
 <1281708884-15462-3-git-send-email-raja_mani@ti.com>
 <1281708884-15462-4-git-send-email-raja_mani@ti.com>
 <1281708884-15462-5-git-send-email-raja_mani@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja-Mani <x0102026@ti.com>

Add new menu option in Kconfig and compilation option in
Makefile for FM driver.

Signed-off-by: Raja-Mani <x0102026@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/Kconfig  |    8 ++++++++
 drivers/staging/ti-st/Makefile |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ti-st/Kconfig b/drivers/staging/ti-st/Kconfig
index 68ad3d0..4019c15 100644
--- a/drivers/staging/ti-st/Kconfig
+++ b/drivers/staging/ti-st/Kconfig
@@ -22,4 +22,12 @@ config ST_BT
 	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
 	  This makes use of shared transport line discipline core driver to
 	  communicate with the BT core of the combo chip.
+
+config ST_FM
+	tristate "fm driver for ST"
+	select TI_ST
+	help
+	  This enables the FM driver for TI BT/FM/GPS combo devices
+	  This makes use of shared transport line discipline core driver to
+	  communicate with the FM core of the combo chip.
 endmenu
diff --git a/drivers/staging/ti-st/Makefile b/drivers/staging/ti-st/Makefile
index 0167d1d..e6af3f1 100644
--- a/drivers/staging/ti-st/Makefile
+++ b/drivers/staging/ti-st/Makefile
@@ -5,3 +5,5 @@
 obj-$(CONFIG_TI_ST) 		+= st_drv.o
 st_drv-objs			:= st_core.o st_kim.o st_ll.o
 obj-$(CONFIG_ST_BT) 		+= bt_drv.o
+obj-$(CONFIG_ST_FM) 		+= fm_drv.o
+fm_drv-objs     		:= fmdrv_common.o fmdrv_rx.o fmdrv_v4l2.o
-- 
1.5.6.3


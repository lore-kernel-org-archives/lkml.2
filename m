Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0JEW4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:56:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59583 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab0JEW4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:56:15 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 4/4] drivers:misc: modify Kconfig & Makefile for TI_ST
Date: Tue,  5 Oct 2010 20:08:37 -0400
Message-Id: <1286323717-2925-5-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1286323717-2925-4-git-send-email-pavan_savoy@ti.com>
References: <1286323717-2925-1-git-send-email-pavan_savoy@ti.com>
 <1286323717-2925-2-git-send-email-pavan_savoy@ti.com>
 <1286323717-2925-3-git-send-email-pavan_savoy@ti.com>
 <1286323717-2925-4-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Add the ti-st folder to list of drivers under drivers/misc.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/Kconfig  |    1 +
 drivers/misc/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 53b21ff..9d0a84d 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -415,5 +415,6 @@ source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
 source "drivers/misc/iwmc3200top/Kconfig"
+source "drivers/misc/ti-st/Kconfig"
 
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 4c771a2..d71d5a7 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
+obj-y				+= ti-st/
-- 
1.6.5


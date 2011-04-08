Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1DHJ5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:57:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37489 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1DHJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:57:51 -0400
From: pavan_savoy@ti.com
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/3] drivers:misc:ti-st: remove rfkill dependency
Date: Fri,  8 Apr 2011 04:57:43 -0500
Message-Id: <1302256664-23688-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1302256664-23688-2-git-send-email-pavan_savoy@ti.com>
References: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
 <1302256664-23688-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

rfkill is no longer used by Texas Instruments shared transport driver to
communicate with user-space.
This patch removes the dependency of rfkill to be enabled to build
shared transport driver in the Kconfig.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
index 2c8c3f3..7c3e106 100644
--- a/drivers/misc/ti-st/Kconfig
+++ b/drivers/misc/ti-st/Kconfig
@@ -5,7 +5,6 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
-	depends on RFKILL
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2D3EPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:15:07 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:47791 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2D3EPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:15:04 -0400
From: Shawn Landden <shawnlandden@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Landden <shawnlandden@gmail.com>
Subject: [PATCH 1/2] input: usbtouchscreen: only expose e2i configure option in expert mode
Date: Sun, 29 Apr 2012 21:14:57 -0700
Message-Id: <1335759297-451-1-git-send-email-shawnlandden@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as is the case of all other devices supported by usbtouchscreen.c

Also list e2i under the composite configure option (TOUCHSCREEN_USB_COMPOSITE)

Signed-off-by: Shawn Landden <shawnlandden@gmail.com>
---
 drivers/input/touchscreen/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 2a21419..a31b05f 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -635,6 +635,7 @@ config TOUCHSCREEN_USB_COMPOSITE
 	  - Zytronic controllers
 	  - Elo TouchSystems 2700 IntelliTouch
 	  - EasyTouch USB Touch Controller from Data Modul
+	  - e2i (Mimo monitors)
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -721,7 +722,7 @@ config TOUCHSCREEN_USB_ELO
 
 config TOUCHSCREEN_USB_E2I
 	default y
-	bool "e2i Touchscreen controller (e.g. from Mimo 740)"
+	bool "e2i Touchscreen controller (e.g. from Mimo 740)" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ZYTRONIC
-- 
1.7.9.5


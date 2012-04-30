Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2D3ERo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:17:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2D3ERn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:17:43 -0400
From: Shawn Landden <shawnlandden@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Landden <shawnlandden@gmail.com>
Subject: [PATCH] input: usbtouchscreen: fix typo
Date: Sun, 29 Apr 2012 21:17:39 -0700
Message-Id: <1335759459-669-1-git-send-email-shawnlandden@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Shawn Landden <shawnlandden@gmail.com>
---
 drivers/input/touchscreen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index a31b05f..350d9db 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -745,7 +745,7 @@ config TOUCHSCREEN_USB_EASYTOUCH
 	bool "EasyTouch USB Touch controller device support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 	help
-	  Say Y here if you have a EasyTouch USB Touch controller device support.
+	  Say Y here if you have an EasyTouch USB Touch controller.
 	  If unsure, say N.
 
 config TOUCHSCREEN_TOUCHIT213
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2KEXVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:21:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58180 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 052/104] drivers/input/keyboard: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:09 -0800
Message-Id: <1352156701-4038-53-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Sourav Poddar <sourav.poddar@ti.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>
CC: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/input/keyboard/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index de08740..4830964 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -134,7 +134,7 @@ config KEYBOARD_QT1070
 
 config KEYBOARD_QT2160
 	tristate "Atmel AT42QT2160 Touch Sensor Chip"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for Atmel AT42QT2160 Touch
 	  Sensor chip as a keyboard input.
-- 
1.7.9.5


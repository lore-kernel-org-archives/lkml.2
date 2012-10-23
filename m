Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581Ab2JWVFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:05:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46808 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933684Ab2JWUFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:10 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 054/193] drivers/input/keyboard: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:07 -0700
Message-Id: <1351022666-6960-55-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

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
index b4b65af..5a83afb 100644
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


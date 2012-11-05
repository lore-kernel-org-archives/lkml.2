Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838Ab2KEXXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:23:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56429 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 053/104] drivers/input/misc: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:10 -0800
Message-Id: <1352156701-4038-54-git-send-email-keescook@chromium.org>
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
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: Andrew Jones <drjones@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/input/misc/Kconfig |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..a7719a2 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -290,8 +290,7 @@ config INPUT_ATI_REMOTE2
 	  called ati_remote2.
 
 config INPUT_KEYSPAN_REMOTE
-	tristate "Keyspan DMR USB remote control (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Keyspan DMR USB remote control"
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -340,7 +339,6 @@ config INPUT_POWERMATE
 
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
-	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -356,7 +354,6 @@ config INPUT_YEALINK
 
 config INPUT_CM109
 	tristate "C-Media CM109 USB I/O Controller"
-	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
@@ -434,7 +431,7 @@ config INPUT_PCF50633_PMU
 
 config INPUT_PCF8574
 	tristate "PCF8574 Keypad input device"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  Say Y here if you want to support a keypad connected via I2C
 	  with a PCF8574.
-- 
1.7.9.5


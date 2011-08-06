Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1HFW2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:28:10 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:39142 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780Ab1HFW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:28:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: dmitry.torokhov@gmail.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] [media] ati_remote: update Kconfig description
Date: Sun,  7 Aug 2011 01:18:13 +0300
Message-Id: <1312669093-23771-8-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
References: <4E3DB2C2.7040104@iki.fi>
 <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ati_remote driver supports more remotes nowadays, update the
description to reflect that.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 drivers/media/rc/Kconfig |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 26937b2..86c6abc 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -98,16 +98,18 @@ config IR_LIRC_CODEC
 	   the LIRC interface.
 
 config RC_ATI_REMOTE
-	tristate "ATI / X10 USB RF remote control"
+	tristate "ATI / X10 based USB RF remote controls"
 	depends on USB_ARCH_HAS_HCD
 	depends on RC_CORE
 	select USB
 	help
-	   Say Y here if you want to use an ATI or X10 "Lola" USB remote control.
+	   Say Y here if you want to use an X10 based USB remote control.
 	   These are RF remotes with USB receivers.
-	   The ATI remote comes with many of ATI's All-In-Wonder video cards.
-	   The X10 "Lola" remote is available at:
-	      <http://www.x10.com/products/lola_sg1.htm>
+
+	   Such devices include the ATI remote that comes with many of ATI's
+	   All-In-Wonder video cards, the X10 "Lola" remote, NVIDIA RF remote,
+	   Medion RF remote, and SnapStream FireFly remote.
+
 	   This driver provides mouse pointer, left and right mouse buttons,
 	   and maps all the other remote buttons to keypress events.
 
-- 
1.7.4.4


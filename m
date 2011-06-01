Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab1FANyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:54:19 -0400
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:34870 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441Ab1FANyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:54:15 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net E3FF11AB8C6
Subject: [PATCH] HID: roccat: Changed plain Kconfig menu to submenu for
 roccat devices.
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 15:54:10 +0200
Message-ID: <1306936450.2486.6.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As module roccat is needed by all devices, it's the toplevel
menu entry with all devices dependent.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/Kconfig |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 67d2a75..14ba3e2 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -434,6 +434,7 @@ config HID_QUANTA
 config HID_ROCCAT
 	tristate "Roccat special event support"
 	depends on USB_HID
+	select HID_ROCCAT_COMMON
 	---help---
 	Support for Roccat special events.
 	Say Y here if you have a Roccat mouse or keyboard and want OSD or
@@ -441,44 +442,40 @@ config HID_ROCCAT
 
 config HID_ROCCAT_COMMON
 	tristate
+	depends on HID_ROCCAT
 
 config HID_ROCCAT_ARVO
 	tristate "Roccat Arvo keyboard support"
 	depends on USB_HID
-	select HID_ROCCAT
-	select HID_ROCCAT_COMMON
+	depends on HID_ROCCAT
 	---help---
 	Support for Roccat Arvo keyboard.
 
 config HID_ROCCAT_KONE
 	tristate "Roccat Kone Mouse support"
 	depends on USB_HID
-	select HID_ROCCAT
-	select HID_ROCCAT_COMMON
+	depends on HID_ROCCAT
 	---help---
 	Support for Roccat Kone mouse.
 
 config HID_ROCCAT_KONEPLUS
 	tristate "Roccat Kone[+] mouse support"
 	depends on USB_HID
-	select HID_ROCCAT
-	select HID_ROCCAT_COMMON
+	depends on HID_ROCCAT
 	---help---
 	Support for Roccat Kone[+] mouse.
 
 config HID_ROCCAT_KOVAPLUS
 	tristate "Roccat Kova[+] mouse support"
 	depends on USB_HID
-	select HID_ROCCAT
-	select HID_ROCCAT_COMMON
+	depends on HID_ROCCAT
 	---help---
 	Support for Roccat Kova[+] mouse.
 
 config HID_ROCCAT_PYRA
 	tristate "Roccat Pyra mouse support"
 	depends on USB_HID
-	select HID_ROCCAT
-	select HID_ROCCAT_COMMON
+	depends on HID_ROCCAT
 	---help---
 	Support for Roccat Pyra mouse.
 
-- 
1.7.3.4




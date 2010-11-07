Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0KGOqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:46:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab0KGOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jWRZZb40DVdwIWl2goTvN0KHcw/y0FmdL0KbI6fBrflxVMRL+JIOPlIOupH3dMt1n4
         gVYs3cJQwbePAgb4Pt7TIvhXxD0Yko5pOduXSr1EE7xsNXtNdoSMJcosFkOdUNwZ56Rp
         Va5NocWkWAWz/FD11h1KH087YnOqBJxfphVDY=
From: Tracey Dent <tdent48227@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: jkosina@suse.cz, chatty@enac.fr, spbnick@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/2] Drivers: hid: Makefile: Cleaned up Makefile
Date: Sun,  7 Nov 2010 09:46:27 -0500
Message-Id: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.161.g3089c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs because -objs is
deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/hid/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index c335605..dad858b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the HID driver
 #
-hid-objs			:= hid-core.o hid-input.o
+hid-y			:= hid-core.o hid-input.o
 
 ifdef CONFIG_DEBUG_FS
 	hid-objs		+= hid-debug.o
@@ -11,18 +11,18 @@ obj-$(CONFIG_HID)		+= hid.o
 
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
-hid-logitech-objs		:= hid-lg.o
+hid-logitech-y		:= hid-lg.o
 ifdef CONFIG_LOGITECH_FF
-	hid-logitech-objs	+= hid-lgff.o
+	hid-logitech-y	+= hid-lgff.o
 endif
 ifdef CONFIG_LOGIRUMBLEPAD2_FF
-	hid-logitech-objs	+= hid-lg2ff.o
+	hid-logitech-y	+= hid-lg2ff.o
 endif
 ifdef CONFIG_LOGIG940_FF
-	hid-logitech-objs	+= hid-lg3ff.o
+	hid-logitech-y	+= hid-lg3ff.o
 endif
 ifdef CONFIG_LOGIWII_FF
-	hid-logitech-objs	+= hid-lg4ff.o
+	hid-logitech-y	+= hid-lg4ff.o
 endif
 
 obj-$(CONFIG_HID_3M_PCT)	+= hid-3m-pct.o
-- 
1.7.3.1.104.gc752e


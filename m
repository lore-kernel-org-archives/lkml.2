Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KGOqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:46:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0KGOqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:46:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KYLRtvRmcT9edoA2o1wAyd2seuYn9J7rLuiWTsT5tsM8SvV/tIWE3cAxLZ0vNVazEJ
         VhH0Rb1OqQpaKTtADvajBwcVK2luxthJZtv+hNOsLZr1bE47+nOwDSjo+AkQ+o80zofT
         SxZ8ab4ie+JWOBKNp6egtuC4jfb1LXgkK3FZM=
From: Tracey Dent <tdent48227@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: jkosina@suse.cz, chatty@enac.fr, spbnick@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/2] Drivers: hid: usbhid: Makefile: Cleaned up Makefile
Date: Sun,  7 Nov 2010 09:46:28 -0500
Message-Id: <1289141188-1447-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.161.g3089c
In-Reply-To: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
References: <1289141188-1447-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs because -objs is
deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/hid/usbhid/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/Makefile b/drivers/hid/usbhid/Makefile
index 1329ecb..db3cf31 100644
--- a/drivers/hid/usbhid/Makefile
+++ b/drivers/hid/usbhid/Makefile
@@ -3,15 +3,15 @@
 #
 
 # Multipart objects.
-usbhid-objs	:= hid-core.o hid-quirks.o
+usbhid-y	:= hid-core.o hid-quirks.o
 
 # Optional parts of multipart objects.
 
 ifeq ($(CONFIG_USB_HIDDEV),y)
-	usbhid-objs	+= hiddev.o
+	usbhid-y	+= hiddev.o
 endif
 ifeq ($(CONFIG_HID_PID),y)
-	usbhid-objs	+= hid-pidff.o
+	usbhid-y	+= hid-pidff.o
 endif
 
 obj-$(CONFIG_USB_HID)		+= usbhid.o
-- 
1.7.3.1.104.gc752e


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2ECArd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:47:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:51901 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2ECArb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:47:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1336006050!21173266!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] backlight: apple_bl.c: include header for exported symbol prototypes
Date: Wed, 2 May 2012 17:47:26 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, <rpurdie@rpsys.net>,
        <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021747.26813.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the header to pickup the exported symbol prototype.

Quites the sparse warning:

warning: symbol 'apple_bl_register' was not declared. Should it be static?
warning: symbol 'apple_bl_unregister' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

---

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index a523b25..ef5ca0d 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/atomic.h>
+#include <linux/apple_bl.h>
 
 static struct backlight_device *apple_backlight_device;
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab2CLQCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:02:52 -0400
Received: from host171.canaca.com ([67.55.55.225]:53365 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2CLQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:02:49 -0400
X-Greylist: delayed 2702 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2012 12:02:49 EDT
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>, Simon Wood <simon@mungewell.org>
Subject: [PATCH 2/2] HID: hid-lg4ff clean up attribution
Date: Mon, 12 Mar 2012 08:17:39 -0700
Message-Id: <1331565459-1892-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331565459-1892-1-git-send-email-simon@mungewell.org>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper attribution for Michal (who re-wrote significant
portions of this driver last year) and clarifies that it now supports
most of the Logitech gaming wheels (not just the Speed Force Wireless).

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/Kconfig     |    1 +
 drivers/hid/hid-lg4ff.c |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a421abd..1a7fd8c 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -307,6 +307,7 @@ config LOGIWHEELS_FF
 	  - Logitech G27
 	  - Logitech MOMO/MOMO 2
 	  - Logitech Formula Force EX
+	  - Logitech Speed Force Wireless (Wii)
 
 config HID_MAGICMOUSE
 	tristate "Apple MagicMouse multi-touch support"
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 4f3b744..bad760d 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -1,9 +1,13 @@
 /*
- *  Force feedback support for Logitech Speed Force Wireless
+ *  Force feedback support for Logitech Gaming Wheels
+ *
+ *  Including: MOMO, MOMO2, DFGT, DFP, G25, G27
+ *    and Speed Force Wireless (Wii)
  *
  *  http://wiibrew.org/wiki/Logitech_USB_steering_wheel
  *
  *  Copyright (c) 2010 Simon Wood <simon@mungewell.org>
+ *  Copyright (c) 2011 Michal Maly <madcatxster@gmail.com>
  */
 
 /*
@@ -536,7 +540,7 @@ int lg4ff_init(struct hid_device *hid)
 		hid_lg4ff_set_leds(hid, 0);
 	}
 
-	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by Simon Wood <simon@mungewell.org>\n");
+	hid_info(hid, "Force feedback for Logitech Gaming Wheels\n");
 	return 0;
 }
 
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2BIPaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:30:16 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37563
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754281Ab2BIPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:30:15 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] zd1211rw: Fix typo in zd_usb.c and zd_mac.c
Date: Fri, 10 Feb 2012 00:29:32 +0900
Message-Id: <1328801372-2532-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/net/wireless/zd1211rw/zd_usb.c
drivers/net/wireless/zd1211rw/zd_mac.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 0a70149..a8370eb 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -846,7 +846,7 @@ reset_device:
 
 	/* semaphore stuck, reset device to avoid fw freeze later */
 	dev_warn(zd_mac_dev(mac), "CR_BCN_FIFO_SEMAPHORE stuck, "
-				  "reseting device...");
+				  "resetting device...");
 	usb_queue_reset_device(mac->chip.usb.intf);
 
 	return r;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 785bdbe..f766b3e 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1104,7 +1104,7 @@ static void zd_tx_watchdog_handler(struct work_struct *work)
 		goto out;
 
 	/* TX halted, try reset */
-	dev_warn(zd_usb_dev(usb), "TX-stall detected, reseting device...");
+	dev_warn(zd_usb_dev(usb), "TX-stall detected, resetting device...");
 
 	usb_queue_reset_device(usb->intf);
 
-- 
1.7.6.5


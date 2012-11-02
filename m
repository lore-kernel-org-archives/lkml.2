Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab2KBJUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:20:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45046 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2KBJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:20:19 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devendra.aaru@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: hfa384x_usb.c: fixed a coding style issue
Date: Fri,  2 Nov 2012 02:19:45 -0700
Message-Id: <1351847985-974-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl throws error message for the current code. This patch fixes
coding style issue.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index f180c3d..c1a8cb6 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -171,11 +171,11 @@ static void hfa384x_ctlxout_callback(struct urb *urb);
 static void hfa384x_usbin_callback(struct urb *urb);
 
 static void
-hfa384x_usbin_txcompl(wlandevice_t *wlandev, hfa384x_usbin_t * usbin);
+hfa384x_usbin_txcompl(wlandevice_t *wlandev, hfa384x_usbin_t *usbin);
 
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb);
 
-static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t * usbin);
+static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t *usbin);
 
 static void
 hfa384x_usbout_tx(wlandevice_t *wlandev, hfa384x_usbout_t *usbout);
@@ -285,7 +285,7 @@ static inline const char *ctlxstr(CTLX_STATE s)
 	return ctlx_str[s];
 };
 
-static inline hfa384x_usbctlx_t *get_active_ctlx(hfa384x_t * hw)
+static inline hfa384x_usbctlx_t *get_active_ctlx(hfa384x_t *hw)
 {
 	return list_entry(hw->ctlxq.active.next, hfa384x_usbctlx_t, list);
 }
-- 
1.7.9.5


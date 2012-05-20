Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2ETNfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:35:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37055 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2ETNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:35:01 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging/wlan-ng: Fix checkpatch warnings
Date: Sun, 20 May 2012 19:04:55 +0530
Message-Id: <1337520895-23177-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 8588417..7a0c9ef 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -138,7 +138,7 @@ typedef struct p80211_frmrx_t {
 } p80211_frmrx_t;
 
 /* called by /proc/net/wireless */
-struct iw_statistics *p80211wext_get_wireless_stats(netdevice_t * dev);
+struct iw_statistics *p80211wext_get_wireless_stats(netdevice_t *dev);
 /* wireless extensions' ioctls */
 extern struct iw_handler_def p80211wext_handler_def;
 int p80211wext_event_associated(struct wlandevice *wlandev, int assoc);
-- 
1.7.9.5


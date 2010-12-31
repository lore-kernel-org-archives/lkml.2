Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0LaFtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0LaFtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NwUkjIzuxoMpWTo2uuYjpAI2IsZDARyXLrG028+zaxADtuGRy9XAMhAS9Tg4fqekPb
         Hk3vU5OJ1FB/LnWX+KAH/9+LDwtmo62serADAKSeFuTdV+t5hHXlCgPJh4wW1VHw3u5e
         7G5OD2GpmWgXeqeNsQvmiv5GTNRHFyTS7hwbM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 12/15]drivers:staging:rtl8187se:ieee80211:ieee80211.h Fix some comments.
Date: Thu, 30 Dec 2010 21:48:48 -0800
Message-Id: <1293774531-5294-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-12-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-8-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-9-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-10-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-11-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-12-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index dc608c7..e54f88f 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -1106,7 +1106,7 @@ struct ieee80211_device {
 
 	/* used instead of hard_start_xmit (not softmac_hard_start_xmit)
 	 * if the IEEE_SOFTMAC_TX_QUEUE feature is used to TX data
-	 * frames. I the option IEEE_SOFTMAC_SINGLE_QUEUE is also set
+	 * frames. If the option IEEE_SOFTMAC_SINGLE_QUEUE is also set
 	 * then also management frames are sent via this callback.
 	 * This function can't sleep.
 	 */
@@ -1124,7 +1124,7 @@ struct ieee80211_device {
 
 	/* ask to the driver to retune the radio .
 	 * This function can sleep. the driver should ensure
-	 * the radio has been swithced before return.
+	 * the radio has been switched before return.
 	 */
 	void (*set_chan)(struct net_device *dev,short ch);
 
@@ -1138,9 +1138,9 @@ struct ieee80211_device {
 	 * it is called in a work_queue when swithcing to ad-hoc mode
 	 * or in behalf of iwlist scan when the card is associated
 	 * and root user ask for a scan.
-	 * the fucntion stop_scan should stop both the syncro and
+	 * the function stop_scan should stop both the syncro and
 	 * background scanning and can sleep.
-	 * The fucntion start_scan should initiate the background
+	 * The function start_scan should initiate the background
 	 * scanning and can't sleep.
 	 */
 	void (*scan_syncro)(struct net_device *dev);
@@ -1199,7 +1199,7 @@ struct ieee80211_device {
 /* Generate respones to probe requests */
 #define IEEE_SOFTMAC_PROBERS (1<<5)
 
-/* The ieee802.11 stack will manages the netif queue
+/* The ieee802.11 stack will manage the netif queue
  * wake/stop for the driver, taking care of 802.11
  * fragmentation. See softmac.c for details. */
 #define IEEE_SOFTMAC_TX_QUEUE (1<<7)
-- 
1.6.5.2.180.gc5b3e


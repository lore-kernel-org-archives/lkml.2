Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0LaFtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0LaFtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CDv0D5XckC0af/vtfVN0sQsP7yaeDa6i+Yk/N7RNhWXPbhKujNX15Fg3H3wEW1qEO2
         1283iGsxJ2GEkabq15G43Al8RCfIuMZyp554x89S51EvnhT8vBKP2u3QtgG1tE6BHzuy
         rsxD6e2TWO4aodL4T6XvDfEFEpFasK7rFlUdA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 07/15]drivers:staging:rtl8187se:r8180_wx.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:43 -0800
Message-Id: <1293774531-5294-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_wx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 39ef7e0..ef1def6 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -13,7 +13,7 @@
 
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
 
-	We want to tanks the Authors of those projects and the Ndiswrapper
+	We want to thanks the Authors of those projects and the Ndiswrapper
 	project Authors.
 */
 
@@ -1529,7 +1529,7 @@ static inline int is_same_network(struct ieee80211_network *src,
 			(dst->capability & WLAN_CAPABILITY_BSS)));
 }
 
-/* WB modefied to show signal to GUI on 18-01-2008 */
+/* WB modified to show signal to GUI on 18-01-2008 */
 static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-- 
1.6.5.2.180.gc5b3e


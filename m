Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0LaAJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:09:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52543 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0LaAJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DQIANgTxBGFN4o3hHor32uWvkBF83CNORzOCc8EA2w1C8gObpbwutassIna6XNshcq
         B3zzHes+nVRRt3iN/wU+LsMyAukFy8+V3rWpQlnxxNMXCDgI3yx00iFCye4UqOYCM25K
         Vd1bIf+ZZAJ2unsRFCsDvpolWxLve58YdmXGI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/5]drivers:staging:rtl8187se:r8180_core.c Typo change singal to signal
Date: Thu, 30 Dec 2010 16:09:44 -0800
Message-Id: <1293754184-1928-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293754184-1928-4-git-send-email-justinmattock@gmail.com>
References: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
 <1293754184-1928-2-git-send-email-justinmattock@gmail.com>
 <1293754184-1928-3-git-send-email-justinmattock@gmail.com>
 <1293754184-1928-4-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches below fixes a typo "singal" to "signal". Please let me 
know if anything needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 70ab008..1ccae4b 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1329,7 +1329,7 @@ u16 N_DBPSOfRate(u16 DataRate)
 }
 
 /*
- * For Netgear case, they want good-looking singal strength.
+ * For Netgear case, they want good-looking signal strength.
  */
 long NetgearSignalStrengthTranslate(long LastSS, long CurrSS)
 {
@@ -1625,7 +1625,7 @@ void rtl8180_rx(struct net_device *dev)
 				 * of correctness. */
 				PerformUndecoratedSignalSmoothing8185(priv, bCckRate);
 
-				/* For good-looking singal strength. */
+				/* For good-looking signal strength. */
 				SignalStrengthIndex = NetgearSignalStrengthTranslate(
 								priv->LastSignalStrengthInPercent,
 								priv->SignalStrength);
-- 
1.6.5.2.180.gc5b3e


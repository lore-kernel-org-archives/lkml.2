Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0LaFtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0LaFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DkZgBCKE9N1GnclN5YQatQ/VoVEdqx0eA5BWNRl19UIrzeq4v1AT8SEoZbApRyk0iQ
         vBHPMWdF0dFJC5TCRNcXXJylp6iQIh7wy8pYRCvA/Vn6IDhqr4CbUSWRW/gEz69I8ndY
         2Fb59XY4URrj1xsH6+NbSTkMb9TTNnSyR31Ng=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/15]drivers:staging:rtl8187se:r8185b_init.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:45 -0800
Message-Id: <1293774531-5294-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-9-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-8-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-9-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8185b_init.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 3bdf9b3..31e6810 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -1103,7 +1103,7 @@ ActUpdateChannelAccessSetting(
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 
-				/*  Retrive paramters to udpate. */
+				/*  Retreive paramters to update. */
 				eACI = pAcParam->f.AciAifsn.f.ACI;
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * ChnlAccessSetting->SlotTimeTimer + aSifsTime;
 				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
@@ -1338,7 +1338,7 @@ MgntDisconnect(
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
-		Schedule an workitem to wake up for ps mode, 070109, by rcnjko.
+		Schedule a workitem to wake up for ps mode, 070109, by rcnjko.
 	*/
 
 	if (IS_DOT11D_ENABLE(priv->ieee80211))
@@ -1549,7 +1549,7 @@ IPSEnter(
 			Do not enter IPS in the following conditions:
 			(1) RF is already OFF or Sleep
 			(2) bSwRfProcessing (indicates the IPS is still under going)
-			(3) Connectted (only disconnected can trigger IPS)
+			(3) Connected (only disconnected can trigger IPS)
 			(4) IBSS (send Beacon)
 			(5) AP mode (send Beacon)
 		*/
@@ -1652,7 +1652,7 @@ void rtl8185b_adapter_start(struct net_device *dev)
 
 	/*
 		We assume RegWirelessMode has already been initialized before,
-		however, we has to validate the wireless mode here and provide a
+		however, we have to validate the wireless mode here and provide a
 		reasonable initialized value if necessary. 2005.01.13, by rcnjko.
 	*/
 	SupportedWirelessMode = GetSupportedWirelessMode8185(dev);
-- 
1.6.5.2.180.gc5b3e


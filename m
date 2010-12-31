Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0LaFtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0LaFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ES+CDItgHpt443drxWzFuOZXktPM/tHGVMF+3Epe4/RPWTm45gxCO6D0JAgVdbe8gp
         wlymg7msaQoLJn+zu6w47RWs7h9waRbsKsf6q8f33SI76u/yQFMrlPCMjX0V4Z3vhFeO
         YLc1s7bb5dcymfMU4e/6cbRrXKO45foRZErYQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/15]drivers:staging:rtl8187se:r8180_rtl8225z2.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:42 -0800
Message-Id: <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_rtl8225z2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index 2a2afd5..47297ab 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -479,7 +479,7 @@ s8 DbmToTxPwrIdx(struct r8180_priv *priv, WIRELESS_MODE WirelessMode,
 
 	/*
 	 * TRUE if we want to use a default implementation.
-	 * We shall set it to FALSE when we have exact translation formular
+	 * We shall set it to FALSE when we have exact translation formula
 	 * for target IC. 070622, by rcnjko.
 	 */
 	if (bUseDefault) {
@@ -688,7 +688,7 @@ void rtl8225z2_rf_init(struct net_device *dev)
 
 	write_rtl8225(dev, 0x2, 0xc4d);
 
-	/* FIXME!! rtl8187 we have to check if calibrarion
+	/* FIXME!! rtl8187 we have to check if calibration
 	 * is successful and eventually cal. again (repeat
 	 * the two write on reg 2)
 	 */
-- 
1.6.5.2.180.gc5b3e


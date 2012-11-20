Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2KTURT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:17:19 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33636 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2KTURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:17:18 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] staging/rtl8187se: Fix spacing coding style in r8185b_init.c
Date: Wed, 21 Nov 2012 05:17:13 +0900
Message-Id: <1353442633-26897-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353442597-26859-1-git-send-email-yamanetoshi@gmail.com>
References: <1353442597-26859-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors and warnings fixed.
- ERROR: space prohibited after that open parenthesis '('
- ERROR: space prohibited before that close parenthesis ')'
- ERROR: space required before the open parenthesis '('
- WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 28611c2..f1db9e4 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -1056,13 +1056,13 @@ void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
 	ieee->mode = (WIRELESS_MODE)btWirelessMode;
 
 	/* 3. Change related setting. */
-	if( ieee->mode == WIRELESS_MODE_A ) {
+	if (ieee->mode == WIRELESS_MODE_A)
 		DMESG("WIRELESS_MODE_A\n");
-	} else if( ieee->mode == WIRELESS_MODE_B ) {
+	else if (ieee->mode == WIRELESS_MODE_B)
 		DMESG("WIRELESS_MODE_B\n");
-	} else if( ieee->mode == WIRELESS_MODE_G ) {
+	else if (ieee->mode == WIRELESS_MODE_G)
 		DMESG("WIRELESS_MODE_G\n");
-	}
+
 	ActUpdateChannelAccessSetting( dev, ieee->mode, &priv->ChannelAccessSetting);
 }
 
-- 
1.7.9.5


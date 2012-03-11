Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2CKE57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 23:57:59 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2CKE56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 23:57:58 -0500
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Miller <amiller@amilx.com>
Subject: [PATCH] Staging: rtl8187se: r8180_core.c: Fix spacing issue
Date: Sat, 10 Mar 2012 23:56:38 -0500
Message-Id: <1331441798-3507-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spacing coding style issues

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   46 +++++++++++++++++--------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 05f25eb..6a0c592 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2617,28 +2617,32 @@ void watch_dog_adaptive(unsigned long data)
 }
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	36,40,44,48,52,56,60,64},19},		/* FCC */
-	{{1,2,3,4,5,6,7,8,9,10,11},11},		/* IC */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,36,40,44,48,52,56,60,64},21},	/* ETSI */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,36,40,44,48,52,56,60,64},21},	/* Spain. Change to ETSI. */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,36,40,44,48,52,56,60,64},21},	/* France. Change to ETSI. */
-	{{14,36,40,44,48,52,56,60,64},9},	/* MKK */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,14, 36,40,44,48,52,56,60,64},22}, /* MKK1 */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,36,40,44,48,52,56,60,64},21},	/* Israel. */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,34,38,42,46},17},			/* For 11a , TELEC */
-	{{1,2,3,4,5,6,7,8,9,10,11,
-	12,13,14},14},  /* For Global Domain. 1-11:active scan,
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	36, 40, 44, 48, 52, 56, 60, 64}, 19},	/* FCC */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11}, /* IC */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* ETSI */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* Spain. Change
+						       * to ETSI. */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* France. Change
+						       * to ETSI. */
+	{{ 14, 36, 40, 44, 48, 52, 56, 60, 64}, 9}, /* MKK */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22}, /* MKK1 */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21}, /* Israel. */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 34, 38, 42, 46}, 17},		/* For 11a , TELEC */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
+	12, 13, 14}, 14},  /* For Global Domain. 1-11:active scan,
 			 * 12-14 passive scan. //+YJ, 080626 */
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13} /* world wide 13: ch1~ch11 active
-					      * scan, ch12~13 passive //lzm
-					      * add 080826 */
+	{{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}, 13} /* world wide 13:
+							    * ch1~ch11 active
+					      		    * scan, ch12~13
+					      		    * passive //lzm
+					      		    * add 080826 */
 };
 
 static void rtl8180_set_channel_map(u8 channel_plan,
-- 
1.7.7.6


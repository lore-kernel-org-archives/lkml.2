Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0C2XM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:12:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33017 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0C2XM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VW7O/52YvzQnPRdzZrcQW9R5l0unh7CNfQMXgsTk1RPMSWiUFm1KtVVMach3/GiqOC
         GQrY8SRihozbCFgZACgFjcnu1W0KsXU5QCSYSF26olHHG9kYHyWOFSPxSHT0AijSeqoD
         3df1R9V5sBridAEjiATs1cplLxJmarl0B5Eac=
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Luis de Bethencourt <luisbg@ubuntu.com>
Subject: [PATCH 2/2] ath: fix macros coding style issue in regd.c
Date: Tue, 30 Mar 2010 00:12:19 +0100
Message-Id: <1269904339-15599-1-git-send-email-luisbg@ubuntu.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <regd.c>
References: <regd.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ath/regd.c file that fixes up three warnings
about macros found by the checkpatch.pl tool, these said that
complex values should be enclosed in parenthesis.

Signed-off-by: Luis de Bethencourt <luisbg@ubuntu.com>
---
 drivers/net/wireless/ath/regd.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 04abd1f..971edc4 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -45,15 +45,16 @@
 #define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 40, 0, 30,\
 				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
 
-#define ATH9K_2GHZ_ALL		ATH9K_2GHZ_CH01_11, \
+#define ATH9K_2GHZ_ALL		(ATH9K_2GHZ_CH01_11, \
 				ATH9K_2GHZ_CH12_13, \
-				ATH9K_2GHZ_CH14
+				ATH9K_2GHZ_CH14)
+
+#define ATH9K_5GHZ_ALL		(ATH9K_5GHZ_5150_5350, \
+				ATH9K_5GHZ_5470_5850)
 
-#define ATH9K_5GHZ_ALL		ATH9K_5GHZ_5150_5350, \
-				ATH9K_5GHZ_5470_5850
 /* This one skips what we call "mid band" */
-#define ATH9K_5GHZ_NO_MIDBAND	ATH9K_5GHZ_5150_5350, \
-				ATH9K_5GHZ_5725_5850
+#define ATH9K_5GHZ_NO_MIDBAND	(ATH9K_5GHZ_5150_5350, \
+				ATH9K_5GHZ_5725_5850)
 
 /* Can be used for:
  * 0x60, 0x61, 0x62 */
-- 
1.6.3.3


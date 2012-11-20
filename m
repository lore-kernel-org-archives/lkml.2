Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2KTMNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:13:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57833 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTMNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:13:10 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 12/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_ccmp.c
Date: Tue, 20 Nov 2012 21:13:05 +0900
Message-Id: <1353413585-24820-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following error and warning fixed.
- ERROR: code indent should use tabs where possible
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 40217b7..f5949e8 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -129,7 +129,7 @@ static void ccmp_init_blocks(struct crypto_tfm *tfm,
 	/*
 	qc_included = ((WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA) &&
 		       (WLAN_FC_GET_STYPE(fc) & 0x08));
-        */
+	*/
 	// fixed by David :2006.9.6
 	qc_included = ((WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA) &&
 		       (WLAN_FC_GET_STYPE(fc) & 0x80));
@@ -340,9 +340,9 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	}
 
 	if (memcmp(mic, a, CCMP_MIC_LEN) != 0) {
-		if (net_ratelimit()) {
+		if (net_ratelimit())
 			pr_debug("decrypt failed: STA=%pM\n", hdr->addr2);
-		}
+
 		key->dot11RSNAStatsCCMPDecryptErrors++;
 		return -5;
 	}
-- 
1.7.9.5


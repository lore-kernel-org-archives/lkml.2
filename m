Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2KTMOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:14:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39311 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2KTMOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:14:04 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 16/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_wep.c
Date: Tue, 20 Nov 2012 21:13:59 +0900
Message-Id: <1353413639-24956-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors and warnings fixed.
- ERROR: code indent should use tabs where possible
- WARNING: please, no spaces at the start of a line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index bb9a078..bba7714 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -217,7 +217,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	memmove(skb->data + 4, skb->data, hdr_len);
 	skb_pull(skb, 4);
 	skb_trim(skb, skb->len - 4);
-        return 0;
+	return 0;
 }
 
 
@@ -289,5 +289,5 @@ void ieee80211_crypto_wep_exit(void)
 void ieee80211_wep_null(void)
 {
 //	printk("============>%s()\n", __func__);
-        return;
+	return;
 }
-- 
1.7.9.5


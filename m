Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2KTMLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:11:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33589 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2KTMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:17 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 04/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt.c
Date: Tue, 20 Nov 2012 21:11:12 +0900
Message-Id: <1353413473-24546-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
-ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index 623245c..694eae3 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -154,7 +154,7 @@ int ieee80211_unregister_crypto_ops(struct ieee80211_crypto_ops *ops)
 }
 
 
-struct ieee80211_crypto_ops * ieee80211_get_crypto_ops(const char *name)
+struct ieee80211_crypto_ops *ieee80211_get_crypto_ops(const char *name)
 {
 	unsigned long flags;
 	struct list_head *ptr;
@@ -181,7 +181,7 @@ struct ieee80211_crypto_ops * ieee80211_get_crypto_ops(const char *name)
 }
 
 
-static void * ieee80211_crypt_null_init(int keyidx) { return (void *) 1; }
+static void *ieee80211_crypt_null_init(int keyidx) { return (void *) 1; }
 static void ieee80211_crypt_null_deinit(void *priv) {}
 
 static struct ieee80211_crypto_ops ieee80211_crypt_null = {
-- 
1.7.9.5


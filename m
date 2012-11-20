Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2KTMMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:12:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:12:44 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 10/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_ccmp.c
Date: Tue, 20 Nov 2012 21:12:39 +0900
Message-Id: <1353413559-24752-1-git-send-email-yamanetoshi@gmail.com>
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
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index f959675..5465b09 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -64,7 +64,7 @@ void ieee80211_ccmp_aes_encrypt(struct crypto_tfm *tfm,
 	crypto_cipher_encrypt_one((void *)tfm, ct, pt);
 }
 
-static void * ieee80211_ccmp_init(int key_idx)
+static void *ieee80211_ccmp_init(int key_idx)
 {
 	struct ieee80211_ccmp_data *priv;
 
@@ -415,7 +415,7 @@ static int ieee80211_ccmp_get_key(void *key, int len, u8 *seq, void *priv)
 }
 
 
-static char * ieee80211_ccmp_print_stats(char *p, void *priv)
+static char *ieee80211_ccmp_print_stats(char *p, void *priv)
 {
 	struct ieee80211_ccmp_data *ccmp = priv;
 	p += sprintf(p, "key[%d] alg=CCMP key_set=%d "
-- 
1.7.9.5


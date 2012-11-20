Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2KTMLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:11:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64985 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2KTMLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:31 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 05/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt.h
Date: Tue, 20 Nov 2012 21:11:25 +0900
Message-Id: <1353413485-24580-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following error fixed.
-ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.h  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
index b58a3bc..0b4ea43 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
@@ -77,7 +77,7 @@ struct ieee80211_crypt_data {
 
 int ieee80211_register_crypto_ops(struct ieee80211_crypto_ops *ops);
 int ieee80211_unregister_crypto_ops(struct ieee80211_crypto_ops *ops);
-struct ieee80211_crypto_ops * ieee80211_get_crypto_ops(const char *name);
+struct ieee80211_crypto_ops *ieee80211_get_crypto_ops(const char *name);
 void ieee80211_crypt_deinit_entries(struct ieee80211_device *, int);
 void ieee80211_crypt_deinit_handler(unsigned long);
 void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
-- 
1.7.9.5


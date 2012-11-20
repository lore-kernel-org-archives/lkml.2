Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2KTMNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:13:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39311 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2KTMNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:13:39 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 14/16] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_wep.c
Date: Tue, 20 Nov 2012 21:13:32 +0900
Message-Id: <1353413612-24888-1-git-send-email-yamanetoshi@gmail.com>
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
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index c0effee..7254085 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -40,7 +40,7 @@ struct prism2_wep_data {
 };
 
 
-static void * prism2_wep_init(int keyidx)
+static void *prism2_wep_init(int keyidx)
 {
 	struct prism2_wep_data *priv;
 
@@ -248,7 +248,7 @@ static int prism2_wep_get_key(void *key, int len, u8 *seq, void *priv)
 }
 
 
-static char * prism2_wep_print_stats(char *p, void *priv)
+static char *prism2_wep_print_stats(char *p, void *priv)
 {
 	struct prism2_wep_data *wep = priv;
 	p += sprintf(p, "key[%d] alg=WEP len=%d\n",
-- 
1.7.9.5


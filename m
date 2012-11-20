Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2KTMMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:12:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62414 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTMMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:12:30 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 09/16] staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_crypt_ccmp.c
Date: Tue, 20 Nov 2012 21:12:25 +0900
Message-Id: <1353413545-24718-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: Use #include <linux/string.h> instead of <asm/string.h>

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 6aaaa2f..f959675 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -18,7 +18,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
 #include <linux/if_arp.h>
-#include <asm/string.h>
+#include <linux/string.h>
 #include <linux/wireless.h>
 
 #include "ieee80211.h"
-- 
1.7.9.5


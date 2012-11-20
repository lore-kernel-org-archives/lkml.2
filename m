Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KTMLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:11:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40924 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTMLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:45 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 06/16] staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_module.c
Date: Tue, 20 Nov 2012 21:11:40 +0900
Message-Id: <1353413500-24615-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning fixed.
- WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
index 9422573..0ed4c93 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -48,7 +48,7 @@
 #include <linux/types.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <net/arp.h>
 #include <net/net_namespace.h>
 
-- 
1.7.9.5


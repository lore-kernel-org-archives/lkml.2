Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2K1NP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:15:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61762 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2K1NP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:15:58 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/8] staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:15:50 +0900
Message-Id: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning fixed.
- WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 3a72449..ef8bfab 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -39,7 +39,7 @@
 #include <linux/types.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/ctype.h>
 
 #include "ieee80211.h"
-- 
1.7.9.5


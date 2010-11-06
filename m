Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0KFOAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:00:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43868 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0KFOAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oYt3Aq/ER30dtLp1N1I9D4nltRn5RriLcZVZrrhzoGkw5RENEKg6bJNoJwB9RJ03t5
         Vl9Q6XYGJfwi38mEZnQ4kDr+iWvUKB+tWhiwZIsZfV+ZcHZsW4g391ucarWtxb9La1Ej
         i7RxC+tLj5qfqDj+8LuwF6+v2f797V3QhTl6Q=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: wlan-ng: fixed coding style issues in p80211conv.h
Date: Sat,  6 Nov 2010 15:59:50 +0200
Message-Id: <1289051990-8691-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the p80211conv.h file that fixes two 80 character line limit styling issues

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/p80211conv.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.h b/drivers/staging/wlan-ng/p80211conv.h
index eca0391..c5d5011 100644
--- a/drivers/staging/wlan-ng/p80211conv.h
+++ b/drivers/staging/wlan-ng/p80211conv.h
@@ -66,12 +66,14 @@
 #define	P80211_FRMMETA_MAGIC	0x802110
 
 #define P80211SKB_FRMMETA(s) \
-	(((((struct p80211_frmmeta *)((s)->cb))->magic) == P80211_FRMMETA_MAGIC) ? \
+	(((((struct p80211_frmmeta *)((s)->cb))->magic) == \
+	P80211_FRMMETA_MAGIC) ? \
 		((struct p80211_frmmeta *)((s)->cb)) : \
 		(NULL))
 
 #define P80211SKB_RXMETA(s) \
-	(P80211SKB_FRMMETA((s)) ?  P80211SKB_FRMMETA((s))->rx : ((struct p80211_rxmeta *)(NULL)))
+	(P80211SKB_FRMMETA((s)) ?  P80211SKB_FRMMETA((s))->rx : \
+	((struct p80211_rxmeta *)(NULL)))
 
 struct p80211_rxmeta {
 	struct wlandevice *wlandev;
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0KFQX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:23:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63689 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab0KFQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aW0EnEvwy+GcWfvf7OSBzsR5PEqTQFw98SMaxAiur41Eh4tAhL7F6xeEn1du8upl0E
         R5pY1kvqN1kJFxb7O38BzXG9bkeZEtz92Zh21uwPU/2zJlYO7RELEvmbXjALLZD12W0/
         rsgup2cB+QYCDCzHFY/TFkh2DhcwLD68E5HhQ=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, greg@kroah.com, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] Staging: wlan-ng: fix coding style issues in p80211types.h
Date: Sat,  6 Nov 2010 18:23:09 +0200
Message-Id: <1289060589-13808-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch that fixes various coding style issues in p80211types.h. The typedef declarations have been kept as they seem necessary.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/p80211types.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211types.h b/drivers/staging/wlan-ng/p80211types.h
index 41a99c5..9dec859 100644
--- a/drivers/staging/wlan-ng/p80211types.h
+++ b/drivers/staging/wlan-ng/p80211types.h
@@ -141,14 +141,14 @@
 #define P80211DID_LSB_ITEM		(12)
 #define P80211DID_LSB_INDEX		(18)
 #define P80211DID_LSB_ISTABLE		(26)
-#define P80211DID_LSB_ACCESS 		(27)
+#define P80211DID_LSB_ACCESS		(27)
 
 #define P80211DID_MASK_SECTION		(0x0000003fUL)
 #define P80211DID_MASK_GROUP		(0x0000003fUL)
 #define P80211DID_MASK_ITEM		(0x0000003fUL)
 #define P80211DID_MASK_INDEX		(0x000000ffUL)
 #define P80211DID_MASK_ISTABLE		(0x00000001UL)
-#define P80211DID_MASK_ACCESS 		(0x00000003UL)
+#define P80211DID_MASK_ACCESS		(0x00000003UL)
 
 #define P80211DID_MK(a, m, l)	((((u32)(a)) & (m)) << (l))
 
-- 
1.7.1


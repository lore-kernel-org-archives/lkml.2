Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab0LaFt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0LaFtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=co9MITsG/G49AlFM92sAXocfp+o4hDXX+NMyb2pIrP/zqJrlcnIoep6xKqGvARPT3M
         yFCaFKF4WWDYGd2zKK3J526QVC17SHtuugJ/zsBiy67+4xnPO8hP5n+7aOgz6DdmymeQ
         2izvNAdhhJE2vkTNZ5PiKl0X4/iq5pyU8RZyI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 11/15]drivers:staging:rtl8187se:ieee80211:ieee80211_crypt.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:47 -0800
Message-Id: <1293774531-5294-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-11-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-7-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-8-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-9-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-10-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-11-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index c8dbcb9..60b2f7e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -89,8 +89,8 @@ void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
 	*crypt = NULL;
 
 	/* must not run ops->deinit() while there may be pending encrypt or
-	 * decrypt operations. Use a list of delayed deinits to avoid needing
-	 * locking. */
+	 * decrypt operations. Use a list of delayed deinits to avoid locking. 
+	 */
 
 	spin_lock_irqsave(&ieee->lock, flags);
 	list_add(&tmp->list, &ieee->crypt_deinit_list);
-- 
1.6.5.2.180.gc5b3e


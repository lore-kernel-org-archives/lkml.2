Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0LaFtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0LaFtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Skvl7nn6MRvViRV4QaujKa8RNx7ka6gDZYgdCrhT3WzT0teliRhBqQOdE/19NaWIwZ
         yLscLIEEPsw1fBaqldLboGzSe0axhwslic21lC+5CZXdVL84g5Gslw0C5DmKopes3CT3
         Tr0VGcD983mQr2mFaCxouVn6UGgu1I1Bexmhs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 13/15]drivers:staging:rtl8187se:ieee80211:ieee80211_rx.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:49 -0800
Message-Id: <1293774531-5294-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-13-git-send-email-justinmattock@gmail.com>
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
 <1293774531-5294-12-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-13-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 3a72449..6993a6a 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1373,9 +1373,9 @@ inline void ieee80211_process_probe_response(
 	}
 
 	// For Asus EeePc request,
-	// (1) if wireless adapter receive get any 802.11d country code in AP beacon,
+	// (1) if wireless adapter receive gets any 802.11d country code in AP beacon,
 	//	   wireless adapter should follow the country code.
-	// (2)  If there is no any country code in beacon,
+	// (2)  If there is not any country code in beacon,
 	//       then wireless adapter should do active scan from ch1~11 and
 	//       passive scan from ch12~14
 	if(ieee->bGlobalDomain)
-- 
1.6.5.2.180.gc5b3e


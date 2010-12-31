Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0LaAJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:09:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37332 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0LaAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e2qxFUvt+iMdqchHrUCiS9YPAQRpTOpaT/hNdVNyZo2yDmPQmY7gZtKqKjUfIpG+jJ
         wWZEEaXWSP8quKGdMacheKurdYsOvE+BqkcGhH1ZKrMP9rqkSaiyAZw0AxPnv1rVQYI+
         8+yIyKtYN+9Y4A7wiW17OSjk+Quv5jchL1MSI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/5]drivers:staging:rtl8192u:ieee80211:rtl819x_HTProc.c Typo change singal to signal
Date: Thu, 30 Dec 2010 16:09:43 -0800
Message-Id: <1293754184-1928-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293754184-1928-3-git-send-email-justinmattock@gmail.com>
References: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
 <1293754184-1928-2-git-send-email-justinmattock@gmail.com>
 <1293754184-1928-3-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches below fixes a typo "singal" to "signal". Please let me 
know if anything needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 50f4f59..5ef816f 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -921,7 +921,7 @@ u8 HTFilterMCSRate( struct ieee80211_device* ieee, u8* pSupportMCS, u8* pOperate
 	// TODO: adjust our operational rate set  according to our channel bandwidth, STBC and Antenna number
 
 	// TODO: fill suggested rate adaptive rate index and give firmware info using Tx command packet
-	// we also shall suggested the first start rate set according to our singal strength
+	// we also shall suggested the first start rate set according to our signal strength
 	HT_PickMCSRate(ieee, pOperateMCS);
 
 	// For RTL819X, if pairwisekey = wep/tkip, we support only MCS0~7.
-- 
1.6.5.2.180.gc5b3e


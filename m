Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0LaAJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:09:40 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48331 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0LaAJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:09:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qxFf0DYPUm36KSVYNlXEFmNVHk1oYn8UxqG8I6NMPX9pIE1wnmkgqKKZb/Ki918wCK
         zZ1FS/B++tHGpRY6HDh36CvDhf43E3QA304zGchUfr/kRbDrZNgAN4pnKUrgAbg+PTWA
         uY6s3Q/aZXXuWGrWxk2nK0Llcy9cLSUvmqJp8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5]drivers:staging:rtl8192e:ieee80211:rtl819x_HTProc.c Typo change singal to signal
Date: Thu, 30 Dec 2010 16:09:41 -0800
Message-Id: <1293754184-1928-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
References: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches below fixes a typo "singal" to "signal". Please let me 
know if anything needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../staging/rtl8192e/ieee80211/rtl819x_HTProc.c    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
index b0c9c78..1be2b13 100644
--- a/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
@@ -1007,7 +1007,7 @@ u8 HTFilterMCSRate( struct ieee80211_device* ieee, u8* pSupportMCS, u8* pOperate
 	// TODO: adjust our operational rate set  according to our channel bandwidth, STBC and Antenna number
 
 	// TODO: fill suggested rate adaptive rate index and give firmware info using Tx command packet
-	// we also shall suggested the first start rate set according to our singal strength
+	// we also shall suggested the first start rate set according to our signal strength
 	HT_PickMCSRate(ieee, pOperateMCS);
 
 	// For RTL819X, if pairwisekey = wep/tkip, we support only MCS0~7.
-- 
1.6.5.2.180.gc5b3e


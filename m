Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0LaFtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:49:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0LaFtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fw3N402ipycL90KuQ5RqTeL+3ECQNfXDpSlUs6pkpuddDPNbGk7xDRe48wOtx5uBjs
         I4VPlDxDE/6O/2lnv4ihIVpGV7kgZ2X9UaZqqbrM0WKZ/HgLTFfovV4NMD3eepjwKrs8
         LvvIUEcqW3xlif6ZGVgJ/+9dYqNXSuizZPhUs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 10/15]drivers:staging:rtl8187se:ieee80211:dot11d.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:46 -0800
Message-Id: <1293774531-5294-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-10-git-send-email-justinmattock@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/ieee80211/dot11d.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/dot11d.c b/drivers/staging/rtl8187se/ieee80211/dot11d.c
index 309bb8b..0e93eb0 100644
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.c
@@ -55,7 +55,7 @@ Dot11d_Reset(struct ieee80211_device *ieee)
 
 //
 //	Description:
-//		Update country IE from Beacon or Probe Resopnse
+//		Update country IE from Beacon or Probe Response
 //		and configure PHY for operation in the regulatory domain.
 //
 //	TODO:
-- 
1.6.5.2.180.gc5b3e


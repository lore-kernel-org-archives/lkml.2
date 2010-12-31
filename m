Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0LaFs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:48:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0LaFsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LpzrpFgpTtZ7f2Xbas0mFIACOIExCGmXTaxmwDO/0vuNwD8UO9+jA1u8BnEPfRSh5L
         WUD84ZcpMnIw4MVzjNQIq+vZxkPL1K+/TSN0DAQieMAP891r7qD1ipOy3kQGMflA8FVG
         wNgmERsHmzGDe9FxUxzgHiFcjOChRO6KGYLLI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/15]drivers:staging:rtl8187se:r8180.h Fix some comments.
Date: Thu, 30 Dec 2010 21:48:40 -0800
Message-Id: <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index d15bdf6..dbc1ce4 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -11,7 +11,7 @@
 
    Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-   We want to tanks the Authors of those projects and the Ndiswrapper
+   We want to thanks the Authors of those projects and the Ndiswrapper
    project Authors.
 */
 
@@ -235,7 +235,7 @@ typedef struct _link_detect_t
 	u32				LastNumTxUnicast;
 	u32				LastNumRxUnicast;
 
-	bool				bBusyTraffic;    //when it is set to 1, UI cann't scan at will.
+	bool				bBusyTraffic;    //when it is set to 1, UI can't scan at will.
 }link_detect_t, *plink_detect_t;
 
 //YJ,modified,080828,end
@@ -552,7 +552,7 @@ typedef struct r8180_priv
 	bool				bDigMechanism; // TRUE if DIG is enabled, FALSE ow.
 	bool				bRegHighPowerMechanism; // For High Power Mechanism. 061010, by rcnjko.
 	u32					FalseAlarmRegValue;
-	u8					RegDigOfdmFaUpTh; // Upper threhold of OFDM false alarm, which is used in DIG.
+	u8					RegDigOfdmFaUpTh; // Upper threshold of OFDM false alarm, which is used in DIG.
 	u8					DIG_NumberFallbackVote;
 	u8					DIG_NumberUpgradeVote;
 	// For HW antenna diversity, added by Roger, 2008.01.30.
-- 
1.6.5.2.180.gc5b3e


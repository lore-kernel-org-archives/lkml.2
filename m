Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2AXPgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:36:25 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:58283
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751443Ab2AXPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:36:24 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@suse.de
Cc: standby24x7@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] [trivial] staging: Fix typo in ieee80211_rx.c
Date: Wed, 25 Jan 2012 00:35:41 +0900
Message-Id: <1327419341-3796-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "suppported" to "supported" in
drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c

Signed-off-by: Masanari iida<standby24x7@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index c9bdc7f..be2a28c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -237,7 +237,7 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 	#ifdef NOT_YET
 	if (ieee->iw_mode == IW_MODE_MASTER) {
-		printk(KERN_DEBUG "%s: Master mode not yet suppported.\n",
+		printk(KERN_DEBUG "%s: Master mode not yet supported.\n",
 		       ieee->dev->name);
 		return 0;
 /*
-- 
1.7.6.5


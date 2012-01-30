Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2A3Nwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:52:37 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:60082
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753110Ab2A3Nwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:52:36 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] net: Fix typo in ipw2x00/libipw_rx.c
Date: Mon, 30 Jan 2012 22:52:10 +0900
Message-Id: <1327931530-1880-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling in "suppported" to "supported" in
drivers/net/wireless/ipw2x00/libipw_rx.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/ipw2x00/libipw_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index 32a9966..c4955d2 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -172,7 +172,7 @@ libipw_rx_frame_mgmt(struct libipw_device *ieee, struct sk_buff *skb,
 			u16 stype)
 {
 	if (ieee->iw_mode == IW_MODE_MASTER) {
-		printk(KERN_DEBUG "%s: Master mode not yet suppported.\n",
+		printk(KERN_DEBUG "%s: Master mode not yet supported.\n",
 		       ieee->dev->name);
 		return 0;
 /*
-- 
1.7.6.5


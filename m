Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966483Ab2EOTGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:06:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51384 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966266Ab2EOTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:06:34 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] isdn: Fix typo in hfcmulti.c
Date: Wed, 16 May 2012 04:06:39 +0900
Message-Id: <1337108799-14899-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.2.520.g6a4a482
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correcting spelling "extenal" to "external" in hfcmulti.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 0332231..4df24a1 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -1156,7 +1156,7 @@ init_chip(struct hfc_multi *hc)
 	hc->DTMFbase = 0x1000;
 	if (test_bit(HFC_CHIP_EXRAM_128, &hc->chip)) {
 		if (debug & DEBUG_HFCMULTI_INIT)
-			printk(KERN_DEBUG "%s: changing to 128K extenal RAM\n",
+			printk(KERN_DEBUG "%s: changing to 128K external RAM\n",
 			       __func__);
 		hc->hw.r_ctrl |= V_EXT_RAM;
 		hc->hw.r_ram_sz = 1;
@@ -1167,7 +1167,7 @@ init_chip(struct hfc_multi *hc)
 	}
 	if (test_bit(HFC_CHIP_EXRAM_512, &hc->chip)) {
 		if (debug & DEBUG_HFCMULTI_INIT)
-			printk(KERN_DEBUG "%s: changing to 512K extenal RAM\n",
+			printk(KERN_DEBUG "%s: changing to 512K external RAM\n",
 			       __func__);
 		hc->hw.r_ctrl |= V_EXT_RAM;
 		hc->hw.r_ram_sz = 2;
-- 
1.7.10.2.520.g6a4a482


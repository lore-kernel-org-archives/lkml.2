Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab2AYOPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:15:30 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37373
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754Ab2AYOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:15:29 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@suse.de, devel@driverdev.osuosl.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] staging: Fix typo in mei/interrupt.c
Date: Wed, 25 Jan 2012 23:14:56 +0900
Message-Id: <1327500896-9670-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/staging/mei/interrupt.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/mei/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 3544fee..e85a85a 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1423,7 +1423,7 @@ void mei_timer(struct work_struct *work)
 
 	if (dev->iamthif_stall_timer) {
 		if (--dev->iamthif_stall_timer == 0) {
-			dev_dbg(&dev->pdev->dev, "reseting because of hang to amthi.\n");
+			dev_dbg(&dev->pdev->dev, "resetting because of hang to amthi.\n");
 			mei_reset(dev, 1);
 			dev->iamthif_msg_buf_size = 0;
 			dev->iamthif_msg_buf_index = 0;
-- 
1.7.6.5


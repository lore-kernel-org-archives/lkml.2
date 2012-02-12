Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2BLOqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:46:35 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52400
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755273Ab2BLOqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:46:34 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] char: Fix typo in tlclk.c
Date: Sun, 12 Feb 2012 23:45:58 +0900
Message-Id: <1329057958-2335-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "telclk_interrup" to "telclk_interrupt" in
drivers/char/tlclk.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/char/tlclk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 0c964cd..ce29e7c 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -797,7 +797,7 @@ static int __init tlclk_init(void)
 	telclk_interrupt = (inb(TLCLK_REG7) & 0x0f);
 
 	if (0x0F == telclk_interrupt ) { /* not MCPBL0010 ? */
-		printk(KERN_ERR "telclk_interrup = 0x%x non-mcpbl0010 hw.\n",
+		printk(KERN_ERR "telclk_interrupt = 0x%x non-mcpbl0010 hw.\n",
 			telclk_interrupt);
 		ret = -ENXIO;
 		goto out3;
-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2ATO4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:56:54 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:48108
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752830Ab2ATO4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:56:53 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] watchdog: Fix typo "unexpectdly"
Date: Fri, 20 Jan 2012 23:56:19 +0900
Message-Id: <1327071379-2881-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "unexpectdly" to "unexpectedly" in pnx4008_wdt.c
and stmp3xxx_wdt.c

Signed-off-by: Masanari Iida<standby24x7@gmail.com>
to: linux-watchdog@vger.kernel.org
cc: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
---
 drivers/watchdog/pnx4008_wdt.c  |    2 +-
 drivers/watchdog/stmp3xxx_wdt.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index bd143c9..8e210aa 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -226,7 +226,7 @@ static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
 static int pnx4008_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		printk(KERN_WARNING "WATCHDOG: Device closed unexpectdly\n");
+		printk(KERN_WARNING "WATCHDOG: Device closed unexpectedly\n");
 
 	wdt_disable();
 	clk_disable(wdt_clk);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index 4c2a4e8..e37d811 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -174,7 +174,7 @@ static int stmp3xxx_wdt_release(struct inode *inode, struct file *file)
 	if (!nowayout) {
 		if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
 			wdt_ping();
-			pr_debug("%s: Device closed unexpectdly\n", __func__);
+			pr_debug("%s: Device closed unexpectedly\n", __func__);
 			ret = -EINVAL;
 		} else {
 			wdt_disable();
-- 
1.7.6.5


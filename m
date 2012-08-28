Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2H1Ekc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:40:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2H1Ekb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:40:31 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] drivrs/video/jz4740_fb.c: Use SIMPLE_DEV_PM_OPS instead of dev_pm_ops
Date: Tue, 28 Aug 2012 01:38:03 -0300
Message-Id: <1346128683-21487-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a cleanup, not functional changes.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---

 Just compile test. Please double check.

 drivers/video/jz4740_fb.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/video/jz4740_fb.c b/drivers/video/jz4740_fb.c
index de36693..a53fb7d 100644
--- a/drivers/video/jz4740_fb.c
+++ b/drivers/video/jz4740_fb.c
@@ -807,12 +807,7 @@ static int jzfb_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops jzfb_pm_ops = {
-	.suspend	= jzfb_suspend,
-	.resume		= jzfb_resume,
-	.poweroff	= jzfb_suspend,
-	.restore	= jzfb_resume,
-};
+static SIMPLE_DEV_PM_OPS(jzfb_pm_ops, jzfb_suspend, jzfb_resume);
 
 #define JZFB_PM_OPS (&jzfb_pm_ops)
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2IFQLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:11:02 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50154 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab2IFQJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:46 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/10] drivers/video/sis/initextlfb.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:15 +0200
Message-Id: <1346947757-10481-8-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/video/sis/initextlfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/video/sis/initextlfb.c b/drivers/video/sis/initextlfb.c
--- a/drivers/video/sis/initextlfb.c
+++ b/drivers/video/sis/initextlfb.c
@@ -65,7 +65,7 @@ sisfb_mode_rate_to_dclock(struct SiS_Pri
     }
 #endif
 
-    if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) {;
+    if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) {
        printk(KERN_ERR "Could not find mode %x\n", ModeNo);
        return 65000;
     }


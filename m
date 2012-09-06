Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2IFQJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:09:46 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41631 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab2IFQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:42 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 10/10] drivers/block/ataflop.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:09 +0200
Message-Id: <1346947757-10481-2-git-send-email-peter.senna@gmail.com>
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
 drivers/block/ataflop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/block/ataflop.c b/drivers/block/ataflop.c
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -775,7 +775,7 @@ static void fd_calibrate( void )
 	}
 
 	if (ATARIHW_PRESENT(FDCSPEED))
-		dma_wd.fdc_speed = 0; 	/* always seek with 8 Mhz */;
+		dma_wd.fdc_speed = 0; 	/* always seek with 8 Mhz */
 	DPRINT(("fd_calibrate\n"));
 	SET_IRQ_HANDLER( fd_calibrate_done );
 	/* we can't verify, since the speed may be incorrect */


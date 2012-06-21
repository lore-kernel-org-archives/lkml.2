Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2FUDSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:18:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51302 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176Ab2FUDSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:18:32 -0400
X-Sasl-enc: 6ycuHzyXbBxAuC6D8DY+7YvJWlccuMstTDvYYuVcWRsh 1340248712
From: Erik Jones <erik@ejnode.com>
To: gregkh@linuxfoundation.org
Cc: bug-track@fisher-privat.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        edwin_rong@realsil.com.cn, Erik Jones <erik@ejnode.com>
Subject: [PATCH] staging: rts5139: rts51x_chip: fixed brace coding style issue
Date: Wed, 20 Jun 2012 23:17:03 -0400
Message-Id: <1340248623-32740-1-git-send-email-erik@ejnode.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Erik Jones <erik@ejnode.com>
---
 drivers/staging/rts5139/rts51x_chip.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_chip.c b/drivers/staging/rts5139/rts51x_chip.c
index db88d7a..08dcae8 100644
--- a/drivers/staging/rts5139/rts51x_chip.c
+++ b/drivers/staging/rts5139/rts51x_chip.c
@@ -363,11 +363,10 @@ void rts51x_polling_func(struct rts51x_chip *chip)
 		break;
 	}
 
-	if (chip->option.auto_delink_en && !chip->card_ready) {
+	if (chip->option.auto_delink_en && !chip->card_ready)
 		rts51x_auto_delink(chip);
-	} else {
+	else
 		chip->auto_delink_counter = 0;
-	}
 }
 
 void rts51x_add_cmd(struct rts51x_chip *chip,
-- 
1.7.9.5


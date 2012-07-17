Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2GQDJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:09:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41291 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351Ab2GQDJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:09:28 -0400
X-Sasl-enc: RqEMzVwFQhFsJ1L5w77oyX2LzEhG5rGzRP03ZmZrYg/r 1342494567
From: Erik Jones <erik@ejnode.com>
To: gregkh@linuxfoundation.org
Cc: edwin_rong@realsil.com.cn, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Erik Jones <erik@ejnode.com>
Subject: [PATCH 2/2] staging: rts5139: rts51x_card: fixed brace coding style issue
Date: Mon, 16 Jul 2012 22:52:34 -0400
Message-Id: <1342493554-16554-3-git-send-email-erik@ejnode.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342493554-16554-1-git-send-email-erik@ejnode.com>
References: <1342493554-16554-1-git-send-email-erik@ejnode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue. An else statement was
not on the same line as the preceding if statement's
closing brace.

Signed-off-by: Erik Jones <erik@ejnode.com>
---
 drivers/staging/rts5139/rts51x_card.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_card.c b/drivers/staging/rts5139/rts51x_card.c
index a3cb559..50be42a 100644
--- a/drivers/staging/rts5139/rts51x_card.c
+++ b/drivers/staging/rts5139/rts51x_card.c
@@ -826,8 +826,7 @@ int card_power_on(struct rts51x_chip *chip, u8 card)
 	if ((card == SD_CARD) || (card == XD_CARD)) {
 		RTS51X_WRITE_REG(chip, CARD_PWR_CTL, mask | LDO3318_PWR_MASK,
 				 val1 | LDO_SUSPEND);
-	}
-	else {
+	} else {
 #endif
 		RTS51X_WRITE_REG(chip, CARD_PWR_CTL, mask, val1);
 #ifdef SD_XD_IO_FOLLOW_PWR
-- 
1.7.9.5


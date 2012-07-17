Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2GQDJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:09:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38736 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab2GQDJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:09:22 -0400
X-Sasl-enc: aAzY6tZWT05dbUqN7RvHHN2J090qA/dw5wRug4E4csf7 1342494561
From: Erik Jones <erik@ejnode.com>
To: gregkh@linuxfoundation.org
Cc: edwin_rong@realsil.com.cn, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Erik Jones <erik@ejnode.com>
Subject: [PATCH 1/2] staging: rts5139: rts51x_card: fixed brace coding style issue
Date: Mon, 16 Jul 2012 22:52:33 -0400
Message-Id: <1342493554-16554-2-git-send-email-erik@ejnode.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342493554-16554-1-git-send-email-erik@ejnode.com>
References: <1342493554-16554-1-git-send-email-erik@ejnode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Erik Jones <erik@ejnode.com>
---
 drivers/staging/rts5139/rts51x_card.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_card.c b/drivers/staging/rts5139/rts51x_card.c
index 4192c3b..a3cb559 100644
--- a/drivers/staging/rts5139/rts51x_card.c
+++ b/drivers/staging/rts5139/rts51x_card.c
@@ -211,13 +211,12 @@ static void card_cd_debounce(struct rts51x_chip *chip, u8 *need_reset,
 				release_map |= MS_CARD;
 		}
 	} else {
-		if (chip->card_status & XD_CD) {
+		if (chip->card_status & XD_CD)
 			reset_map |= XD_CARD;
-		} else if (chip->card_status & SD_CD) {
+		else if (chip->card_status & SD_CD)
 			reset_map |= SD_CARD;
-		} else if (chip->card_status & MS_CD) {
+		else if (chip->card_status & MS_CD)
 			reset_map |= MS_CARD;
-		}
 	}
 
 	if (CHECK_PKG(chip, QFN24) && reset_map) {
-- 
1.7.9.5


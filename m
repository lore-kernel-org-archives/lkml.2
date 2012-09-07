Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2IGEiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:38:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52215 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2IGEiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:38:07 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 50/57] staging/rts_pstor: remove braces {} in sd.c (sd_pass_thru_mode)
Date: Fri,  7 Sep 2012 13:38:02 +0900
Message-Id: <1346992682-17998-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 9091700..b352f20 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3690,9 +3690,8 @@ int sd_pass_thru_mode(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	}
 
 	buf[5] = (1 == CHK_SD(sd_card)) ?  0x01 : 0x02;
-	if (chip->card_wp & SD_CARD) {
+	if (chip->card_wp & SD_CARD)
 		buf[5] |= 0x80;
-	}
 
 	buf[6] = (u8)(sd_card->sd_addr >> 16);
 	buf[7] = (u8)(sd_card->sd_addr >> 24);
-- 
1.7.9.5


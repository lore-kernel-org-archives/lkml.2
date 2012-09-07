Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab2IGEew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:34:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759585Ab2IGEeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:34:50 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 37/57] staging/rts_pstor: remove braces {} in sd.c (sd_check_wp_state)
Date: Fri,  7 Sep 2012 13:34:44 +0900
Message-Id: <1346992484-17576-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 7318349..c9dc000 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2154,9 +2154,8 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
 
 	retval = sd_send_cmd_get_rsp(chip, APP_CMD,
 			sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	cmd[0] = 0x40 | SD_STATUS;
 	cmd[1] = 0;
@@ -2184,9 +2183,8 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
 
 	/* Check SD Machanical Write-Protect Switch */
 	val = rtsx_readl(chip, RTSX_BIPR);
-	if (val & SD_WRITE_PROTECT) {
+	if (val & SD_WRITE_PROTECT)
 		chip->card_wp |= SD_CARD;
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5


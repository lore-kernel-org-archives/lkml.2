Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2IGE3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:29:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58147 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2IGE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:29:34 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 21/57] staging/rts_pstor: remove braces {} in sd.c (sd_ddr_tuning_rx_cmd)
Date: Fri,  7 Sep 2012 13:29:29 +0900
Message-Id: <1346992169-17060-1-git-send-email-yamanetoshi@gmail.com>
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
index 73ed6d8..74c84e8 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1426,16 +1426,14 @@ static int sd_ddr_tuning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	u8 cmd[5];
 
 	retval = sd_change_phase(chip, sample_point, TUNE_RX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_DEBUGP("sd ddr tuning rx\n");
 
 	retval = sd_send_cmd_get_rsp(chip, APP_CMD, sd_card->sd_addr, SD_RSP_TYPE_R1, NULL, 0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	cmd[0] = 0x40 | SD_STATUS;
 	cmd[1] = 0;
-- 
1.7.9.5


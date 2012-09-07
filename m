Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2IGE3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:29:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38153 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2IGE3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:29:51 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 22/57] staging/rts_pstor: remove braces {} in sd.c (mmc_ddr_tunning_rx_cmd)
Date: Fri,  7 Sep 2012 13:29:46 +0900
Message-Id: <1346992186-17092-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for any arm of this statement
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 74c84e8..bc91ff3 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1459,18 +1459,16 @@ static int mmc_ddr_tunning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	int retval;
 	u8 cmd[5], bus_width;
 
-	if (CHK_MMC_8BIT(sd_card)) {
+	if (CHK_MMC_8BIT(sd_card))
 		bus_width = SD_BUS_WIDTH_8;
-	} else if (CHK_MMC_4BIT(sd_card)) {
+	else if (CHK_MMC_4BIT(sd_card))
 		bus_width = SD_BUS_WIDTH_4;
-	} else {
+	else
 		bus_width = SD_BUS_WIDTH_1;
-	}
 
 	retval = sd_change_phase(chip, sample_point, TUNE_RX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_DEBUGP("mmc ddr tuning rx\n");
 
-- 
1.7.9.5


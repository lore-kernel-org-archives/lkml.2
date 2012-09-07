Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2IGEdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:33:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2IGEdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:33:02 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 31/57] staging/rts_pstor: remove braces {} in sd.c (mmc_ddr_tuning)
Date: Fri,  7 Sep 2012 13:32:56 +0900
Message-Id: <1346992376-17381-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 0871a5d..c22689c 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1872,26 +1872,22 @@ static int mmc_ddr_tuning(struct rtsx_chip *chip)
 
 	if (!(chip->sd_ctl & MMC_DDR_TX_PHASE_SET_BY_USER)) {
 		retval = sd_ddr_pre_tuning_tx(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	} else {
 		retval = sd_change_phase(chip, (u8)chip->mmc_ddr_tx_phase, TUNE_TX);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	retval = sd_tuning_rx(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (!(chip->sd_ctl & MMC_DDR_TX_PHASE_SET_BY_USER)) {
 		retval = sd_tuning_tx(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
-- 
1.7.9.5


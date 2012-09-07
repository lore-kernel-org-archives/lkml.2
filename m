Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2IGEaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:30:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38153 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2IGEaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:30:06 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 23/57] staging/rts_pstor: remove braces {} in sd.c (sd_sdr_tuning_tx_cmd)
Date: Fri,  7 Sep 2012 13:30:01 +0900
Message-Id: <1346992201-17124-1-git-send-email-yamanetoshi@gmail.com>
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
index bc91ff3..6088d93 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1496,9 +1496,8 @@ static int sd_sdr_tuning_tx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	int retval;
 
 	retval = sd_change_phase(chip, sample_point, TUNE_TX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, SD_RSP_80CLK_TIMEOUT_EN);
 
-- 
1.7.9.5


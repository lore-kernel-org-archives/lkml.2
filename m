Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2IGE3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:29:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58147 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2IGE3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:29:19 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 20/57] staging/rts_pstor: remove braces {} in sd.c (sd_sdr_tuning_rx_cmd)
Date: Fri,  7 Sep 2012 13:29:15 +0900
Message-Id: <1346992155-17028-1-git-send-email-yamanetoshi@gmail.com>
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
index 558f25b3..73ed6d8 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1398,9 +1398,8 @@ static int sd_sdr_tuning_rx_cmd(struct rtsx_chip *chip, u8 sample_point)
 	u8 cmd[5];
 
 	retval = sd_change_phase(chip, sample_point, TUNE_RX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	cmd[0] = 0x40 | SEND_TUNING_PATTERN;
 	cmd[1] = 0;
-- 
1.7.9.5


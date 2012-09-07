Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2IGEhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:37:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2IGEg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:36:57 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 46/57] staging/rts_pstor: remove braces {} in sd.c (sd_auto_tune_clock)
Date: Fri,  7 Sep 2012 13:36:52 +0900
Message-Id: <1346992612-17867-1-git-send-email-yamanetoshi@gmail.com>
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
index 272b2d4..d0f5512 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3151,9 +3151,8 @@ static inline int sd_auto_tune_clock(struct rtsx_chip *chip)
 	int retval;
 
 	if (chip->asic_code) {
-		if (sd_card->sd_clock > 30) {
+		if (sd_card->sd_clock > 30)
 			sd_card->sd_clock -= 20;
-		}
 	} else {
 		switch (sd_card->sd_clock) {
 		case CLK_200:
@@ -3186,9 +3185,8 @@ static inline int sd_auto_tune_clock(struct rtsx_chip *chip)
 	}
 
 	retval = sd_switch_clock(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5


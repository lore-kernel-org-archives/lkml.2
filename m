Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2IGE1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:27:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62068 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2IGE1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:27:15 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 12/57] staging/rts_pstor: remove braces {} in sd.c (sd_change_bank_voltage)
Date: Fri,  7 Sep 2012 13:27:08 +0900
Message-Id: <1346992029-16769-1-git-send-email-yamanetoshi@gmail.com>
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
index 8228231..ed95a1a 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -774,18 +774,16 @@ static int sd_change_bank_voltage(struct rtsx_chip *chip, u8 voltage)
 	if (voltage == SD_IO_3V3) {
 		if (chip->asic_code) {
 			retval = rtsx_write_phy_register(chip, 0x08, 0x4FC0 | chip->phy_voltage);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		} else {
 			RTSX_WRITE_REG(chip, SD_PAD_CTL, SD_IO_USING_1V8, 0);
 		}
 	} else if (voltage == SD_IO_1V8) {
 		if (chip->asic_code) {
 			retval = rtsx_write_phy_register(chip, 0x08, 0x4C40 | chip->phy_voltage);
-			if (retval != STATUS_SUCCESS) {
+			if (retval != STATUS_SUCCESS)
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		} else {
 			RTSX_WRITE_REG(chip, SD_PAD_CTL, SD_IO_USING_1V8, SD_IO_USING_1V8);
 		}
-- 
1.7.9.5


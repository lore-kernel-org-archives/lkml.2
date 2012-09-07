Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2IGEYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:24:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2IGEYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:24:09 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 06/57] staging/rts_pstor: remove braces {} in sd.c (sd_choose_proper_clock)
Date: Fri,  7 Sep 2012 13:24:03 +0900
Message-Id: <1346991843-16574-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 28fc8a2..4021295 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -622,41 +622,40 @@ static void sd_choose_proper_clock(struct rtsx_chip *chip)
 	struct sd_info *sd_card = &(chip->sd_card);
 
 	if (CHK_SD_SDR104(sd_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			sd_card->sd_clock = chip->asic_sd_sdr104_clk;
-		} else {
+		else
 			sd_card->sd_clock = chip->fpga_sd_sdr104_clk;
-		}
+
 	} else if (CHK_SD_DDR50(sd_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			sd_card->sd_clock = chip->asic_sd_ddr50_clk;
-		} else {
+		else
 			sd_card->sd_clock = chip->fpga_sd_ddr50_clk;
-		}
+
 	} else if (CHK_SD_SDR50(sd_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			sd_card->sd_clock = chip->asic_sd_sdr50_clk;
-		} else {
+		else
 			sd_card->sd_clock = chip->fpga_sd_sdr50_clk;
-		}
+
 	} else if (CHK_SD_HS(sd_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			sd_card->sd_clock = chip->asic_sd_hs_clk;
-		} else {
+		else
 			sd_card->sd_clock = chip->fpga_sd_hs_clk;
-		}
+
 	} else if (CHK_MMC_52M(sd_card) || CHK_MMC_DDR52(sd_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			sd_card->sd_clock = chip->asic_mmc_52m_clk;
-		} else {
+		else
 			sd_card->sd_clock = chip->fpga_mmc_52m_clk;
-		}
+
 	} else if (CHK_MMC_26M(sd_card)) {
-		if (chip->asic_code) {
+		if (chip->asic_code)
 			sd_card->sd_clock = 48;
-		} else {
+		else
 			sd_card->sd_clock = CLK_50;
-		}
 	}
 }
 
-- 
1.7.9.5


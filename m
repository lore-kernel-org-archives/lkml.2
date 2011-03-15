Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1COIWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:22:43 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:36149 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1COIWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:22:38 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p2F8MQoR015086, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH 1/2] staging: rts_pstor: modify initial card clock
Date: Tue, 15 Mar 2011 16:22:06 +0800
X-BOX-Message-Id: p2F8MQoR015086
Message-ID: <1300177326-4442-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Modify initial card clock to avoid over spec

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/rtsx.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 4514419..02525d5 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -824,13 +824,13 @@ static void rtsx_init_options(struct rtsx_chip *chip)
 	chip->fpga_ms_hg_clk = CLK_80;
 	chip->fpga_ms_4bit_clk = CLK_80;
 	chip->fpga_ms_1bit_clk = CLK_40;
-	chip->asic_sd_sdr104_clk = 207;
-	chip->asic_sd_sdr50_clk = 99;
-	chip->asic_sd_ddr50_clk = 99;
-	chip->asic_sd_hs_clk = 99;
-	chip->asic_mmc_52m_clk = 99;
-	chip->asic_ms_hg_clk = 119;
-	chip->asic_ms_4bit_clk = 79;
+	chip->asic_sd_sdr104_clk = 203;
+	chip->asic_sd_sdr50_clk = 98;
+	chip->asic_sd_ddr50_clk = 98;
+	chip->asic_sd_hs_clk = 98;
+	chip->asic_mmc_52m_clk = 98;
+	chip->asic_ms_hg_clk = 117;
+	chip->asic_ms_4bit_clk = 78;
 	chip->asic_ms_1bit_clk = 39;
 	chip->ssc_depth_sd_sdr104 = SSC_DEPTH_2M;
 	chip->ssc_depth_sd_sdr50 = SSC_DEPTH_2M;
-- 
1.7.4.1


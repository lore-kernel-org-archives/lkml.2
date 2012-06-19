Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2FSU1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:27:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55273 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2FSU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:27:43 -0400
From: Fabio Estevam <festevam@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, marex@denx.de,
        kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clk: mxs: Fix the GPMI clock name
Date: Tue, 19 Jun 2012 17:27:32 -0300
Message-Id: <1340137652-2227-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

The correct name for the GPMI clock is 'gpmi-nand'.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/clk/mxs/clk-imx23.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index f7be225..40ad638 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -106,7 +106,7 @@ static struct clk_lookup lcdif_lookups[] __initdata = {
 
 static struct clk_lookup gpmi_lookups[] __initdata = {
 	{ .dev_id = "imx23-gpmi-nand", },
-	{ .dev_id = "8000c000.gpmi", },
+	{ .dev_id = "8000c000.gpmi-nand", },
 };
 
 static const char *sel_pll[]  __initconst = { "pll", "ref_xtal", };
-- 
1.7.1


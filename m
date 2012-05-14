Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2ENQbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:31:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39040 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140Ab2ENQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:31:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: Constify struct clk_init_data
Date: Mon, 14 May 2012 15:12:42 +0100
Message-Id: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to declare their clk_init_data const, the framework really
shouldn't be modifying the data.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/clk-provider.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index c1c23b9..fc43ea6 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -143,7 +143,7 @@ struct clk_init_data {
  */
 struct clk_hw {
 	struct clk *clk;
-	struct clk_init_data *init;
+	const struct clk_init_data *init;
 };
 
 /*
-- 
1.7.10


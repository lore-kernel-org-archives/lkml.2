Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2ENJNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:13:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50921 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212Ab2ENJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:13:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm8400: Export wm8400_block_read()
Date: Mon, 14 May 2012 10:13:16 +0100
Message-Id: <1336986796-31491-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336986796-31491-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336986796-31491-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used by the regulator driver.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8400-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 9083b77..4b7d378 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -60,6 +60,7 @@ int wm8400_block_read(struct wm8400 *wm8400, u8 reg, int count, u16 *data)
 {
 	return regmap_bulk_read(wm8400->regmap, reg, data, count);
 }
+EXPORT_SYMBOL_GPL(wm8400_block_read);
 
 static int wm8400_register_codec(struct wm8400 *wm8400)
 {
-- 
1.7.10


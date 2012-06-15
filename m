Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab2FOSF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:05:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34790 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729Ab2FOSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:05:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: tps65910: Don't use 0 as NULL
Date: Fri, 15 Jun 2012 19:05:23 +0100
Message-Id: <1339783523-18601-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/tps65910-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 6bf864b..e1b01ec 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1136,7 +1136,7 @@ static inline struct tps65910_board *tps65910_parse_dt_reg_data(
 			struct of_regulator_match **tps65910_reg_matches)
 {
 	*tps65910_reg_matches = NULL;
-	return 0;
+	return NULL;
 }
 #endif
 
-- 
1.7.10


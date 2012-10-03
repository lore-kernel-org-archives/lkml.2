Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2JCMnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:43:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56178 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124Ab2JCMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:43:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: lp8788-ldo: Staticise non-exported symbol
Date: Wed,  3 Oct 2012 13:43:00 +0100
Message-Id: <1349268182-21804-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/lp8788-ldo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 6796eeb..e496ba0 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -126,7 +126,7 @@ struct lp8788_ldo {
 };
 
 /* DLDO 1, 2, 3, 9 voltage table */
-const int lp8788_dldo1239_vtbl[] = {
+static const int lp8788_dldo1239_vtbl[] = {
 	1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000,
 	2600000, 2700000, 2800000, 2900000, 3000000, 2850000, 2850000, 2850000,
 	2850000, 2850000, 2850000, 2850000, 2850000, 2850000, 2850000, 2850000,
-- 
1.7.10.4


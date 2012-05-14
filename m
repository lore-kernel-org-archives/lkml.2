Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2ENP6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:58:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2ENP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:58:18 -0400
Message-ID: <1337011088.6054.0.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Fix build error due to missing
 semicolon
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 23:58:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:
  CC [M]  drivers/regulator/tps62360-regulator.o
drivers/regulator/tps62360-regulator.c:351:1: error: expected ',' or ';' before 'extern'
make[2]: *** [drivers/regulator/tps62360-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 60765cc..82cd763 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -347,7 +347,7 @@ static const struct of_device_id tps62360_of_match[] = {
 	 { .compatible = "ti,tps62362", .data = (void *)TPS62362},
 	 { .compatible = "ti,tps62363", .data = (void *)TPS62363},
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, tps62360_of_match);
 #endif
 
-- 
1.7.5.4




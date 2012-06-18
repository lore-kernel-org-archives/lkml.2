Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2FRF7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:59:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55415 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2FRF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:59:12 -0400
Message-ID: <1339999142.18659.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Fix setting constraints->ramp_delay in
 of_get_regulation_constraints
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 18 Jun 2012 13:59:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/of_regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index e2a7310..68dc3d4 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -63,7 +63,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 
 	ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
 	if (ramp_delay)
-		constraints->min_uV = be32_to_cpu(*ramp_delay);
+		constraints->ramp_delay = be32_to_cpu(*ramp_delay);
 }
 
 /**
-- 
1.7.9.5




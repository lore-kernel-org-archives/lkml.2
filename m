Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2EIUSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:18:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47461 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab2EIUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:18:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, AnilKumar Ch <anilkumar@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: tps65217: Staticise non-exported tps65217_update_bis()
Date: Wed,  9 May 2012 21:18:05 +0100
Message-Id: <1336594685-20954-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tps65217.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index f7d854e..1c0fd2b 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -96,7 +96,7 @@ EXPORT_SYMBOL_GPL(tps65217_reg_write);
  * @val: Value to write.
  * @level: Password protected level
  */
-int tps65217_update_bits(struct tps65217 *tps, unsigned int reg,
+static int tps65217_update_bits(struct tps65217 *tps, unsigned int reg,
 		unsigned int mask, unsigned int val, unsigned int level)
 {
 	int ret;
-- 
1.7.10


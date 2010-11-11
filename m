Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0KKSDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:03:10 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1052 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752709Ab0KKSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:03:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23909
From: Lars-Peter Clausen <lars@metafoo.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] MTD: NAND: jz4740: Make 'struct platform_driver jz_nand_driver' static
Date: Thu, 11 Nov 2010 19:02:47 +0100
Message-Id: <1289498568-12191-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mtd/nand/jz4740_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index 67343fc..c9e2a59 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -489,7 +489,7 @@ static int __devexit jz_nand_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct platform_driver jz_nand_driver = {
+static struct platform_driver jz_nand_driver = {
 	.probe = jz_nand_probe,
 	.remove = __devexit_p(jz_nand_remove),
 	.driver = {
-- 
1.5.6.5


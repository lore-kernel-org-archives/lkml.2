Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2JQBAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:00:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51165 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2JQBAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:00:33 -0400
Message-ID: <1350435620.5718.1.camel@phoenix>
Subject: [PATCH] regulator: vexpress: Add terminating entry for
 vexpress_regulator_of_match table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 09:00:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/vexpress.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index 1702945..1d55811 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -126,6 +126,7 @@ static int __devexit vexpress_regulator_remove(struct platform_device *pdev)
 
 static struct of_device_id vexpress_regulator_of_match[] = {
 	{ .compatible = "arm,vexpress-volt", },
+	{ }
 };
 
 static struct platform_driver vexpress_regulator_driver = {
-- 
1.7.9.5




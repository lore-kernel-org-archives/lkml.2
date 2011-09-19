Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1ISOTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:19:32 -0400
Received: from smtp-out-050.synserver.de ([212.40.185.50]:1043 "EHLO
	smtp-out-046.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750713Ab1ISOTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:19:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 9501
From: Lars-Peter Clausen <lars@metafoo.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] mfd: jz4740-adc: Make jz4740_adc_driver static
Date: Mon, 19 Sep 2011 16:19:09 +0200
Message-Id: <1316441949-2277-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/jz4740-adc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 563654c..1e9ee53 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -328,7 +328,7 @@ static int __devexit jz4740_adc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct platform_driver jz4740_adc_driver = {
+static struct platform_driver jz4740_adc_driver = {
 	.probe	= jz4740_adc_probe,
 	.remove = __devexit_p(jz4740_adc_remove),
 	.driver = {
-- 
1.7.2.5


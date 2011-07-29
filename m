Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1G2OfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:35:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33379 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751187Ab1G2OfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:35:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>, Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mmc: sdhci-s3c: Fix build for header change
Date: Fri, 29 Jul 2011 15:35:00 +0100
Message-Id: <1311950100-7508-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A header change has removed an implicit inclusion of module.h, breaking
the build due to the use of THIS_MODULE. Fix that.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mmc/host/sdhci-s3c.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 03da44a..2bd7bf4 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/module.h>
 
 #include <linux/mmc/host.h>
 
-- 
1.7.5.4


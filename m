Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1G2PTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:19:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34076 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153Ab1G2PTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:19:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header change
Date: Fri, 29 Jul 2011 16:19:26 +0100
Message-Id: <1311952766-11693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some header change has removed an implicit include of module.h, breaking
the build due to the use of THIS_MODULE. Fix that.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/cpufreq/s3c64xx-cpufreq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index b8d1d20..3475f65 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/regulator/consumer.h>
+#include <linux/module.h>
 
 static struct clk *armclk;
 static struct regulator *vddarm;
-- 
1.7.5.4


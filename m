Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2HMJdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:33:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51906 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab2HMJdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:33:05 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] davinci: fix build warning when CONFIG_DEBUG_SECTION_MISMATCH is enabled
Date: Mon, 13 Aug 2012 15:02:17 +0530
Message-ID: <1344850337-6852-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/dm355_ccdc.c   |    2 +-
 drivers/media/video/davinci/dm644x_ccdc.c  |    2 +-
 drivers/media/video/davinci/isif.c         |    2 +-
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/davinci/vpif.c         |    2 +-
 drivers/media/video/davinci/vpss.c         |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 5b68847..2eb7dbd 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -1060,7 +1060,7 @@ static int dm355_ccdc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver dm355_ccdc_driver = {
+static __refdata struct platform_driver dm355_ccdc_driver = {
 	.driver = {
 		.name	= "dm355_ccdc",
 		.owner = THIS_MODULE,
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 9303fe5..3ffb7f2 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -1068,7 +1068,7 @@ static const struct dev_pm_ops dm644x_ccdc_pm_ops = {
 	.resume = dm644x_ccdc_resume,
 };
 
-static struct platform_driver dm644x_ccdc_driver = {
+static __refdata struct platform_driver dm644x_ccdc_driver = {
 	.driver = {
 		.name	= "dm644x_ccdc",
 		.owner = THIS_MODULE,
diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
index 5278fe7..6ce4249 100644
--- a/drivers/media/video/davinci/isif.c
+++ b/drivers/media/video/davinci/isif.c
@@ -1148,7 +1148,7 @@ static int isif_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver isif_driver = {
+static __refdata struct platform_driver isif_driver = {
 	.driver = {
 		.name	= "isif",
 		.owner = THIS_MODULE,
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 49a845f..572d8f0 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -2066,7 +2066,7 @@ static const struct dev_pm_ops vpfe_dev_pm_ops = {
 	.resume = vpfe_resume,
 };
 
-static struct platform_driver vpfe_driver = {
+static __refdata struct platform_driver vpfe_driver = {
 	.driver = {
 		.name = CAPTURE_DRV_NAME,
 		.owner = THIS_MODULE,
diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index b3637af..a058fed 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -490,7 +490,7 @@ static const struct dev_pm_ops vpif_pm = {
 #define vpif_pm_ops NULL
 #endif
 
-static struct platform_driver vpif_driver = {
+static __refdata struct platform_driver vpif_driver = {
 	.driver = {
 		.name	= "vpif",
 		.owner = THIS_MODULE,
diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 3e5cf27..8f682d8 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -460,7 +460,7 @@ static int __devexit vpss_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver vpss_driver = {
+static __refdata struct platform_driver vpss_driver = {
 	.driver = {
 		.name	= "vpss",
 		.owner = THIS_MODULE,
-- 
1.7.0.4


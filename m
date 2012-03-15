Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032171Ab2COSvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:51:12 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:33284 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965297Ab2COSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:51:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] mfd: db8500-prcmu: Add 8420 variant
Date: Thu, 15 Mar 2012 19:50:51 +0100
Message-ID: <1331837451-17834-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |    2 ++
 include/linux/mfd/db8500-prcmu.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index b088156..eec8f91 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2500,6 +2500,8 @@ static char *fw_project_name(u8 project)
 		return "U9500 C2";
 	case PRCMU_FW_PROJECT_U8520:
 		return "U8520";
+	case PRCMU_FW_PROJECT_U8420:
+		return "U8420";
 	default:
 		return "Unknown";
 	}
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index aed4e5e..dc4bf4c 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -498,6 +498,7 @@ struct prcmu_auto_pm_config {
 #define PRCMU_FW_PROJECT_U8500_C2	7
 #define PRCMU_FW_PROJECT_U9500_C2	11
 #define PRCMU_FW_PROJECT_U8520		13
+#define PRCMU_FW_PROJECT_U8420		14
 
 struct prcmu_fw_version {
 	u8 project;
-- 
1.7.9.2


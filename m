Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab1F3BcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:32:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40845 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab1F3Bbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:31:52 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-c4-4e0bd203cc8b
Date: Thu, 30 Jun 2011 10:31:47 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
In-reply-to: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 30 Jun 2011 01:32:02.0207 (UTC)
 FILETIME=[830DAAF0:01CC36C5]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ definitions are needed to be accessed by board support package codes
as well. Because they are not only used by MAX8997 MFD device drivers,
this patch pulls such definitions out of private header, which is meant
for MAX8997 MFD device drivers.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/mfd/max8997-private.h |   46 -----------------------------------
 include/linux/mfd/max8997.h         |   46 +++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 5ff2400..4e50a62 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -265,52 +265,6 @@ enum max8997_irq_source {
 	MAX8997_IRQ_GROUP_NR,
 };
 
-enum max8997_irq {
-	MAX8997_PMICIRQ_PWRONR,
-	MAX8997_PMICIRQ_PWRONF,
-	MAX8997_PMICIRQ_PWRON1SEC,
-	MAX8997_PMICIRQ_JIGONR,
-	MAX8997_PMICIRQ_JIGONF,
-	MAX8997_PMICIRQ_LOWBAT2,
-	MAX8997_PMICIRQ_LOWBAT1,
-
-	MAX8997_PMICIRQ_JIGR,
-	MAX8997_PMICIRQ_JIGF,
-	MAX8997_PMICIRQ_MR,
-	MAX8997_PMICIRQ_DVS1OK,
-	MAX8997_PMICIRQ_DVS2OK,
-	MAX8997_PMICIRQ_DVS3OK,
-	MAX8997_PMICIRQ_DVS4OK,
-
-	MAX8997_PMICIRQ_CHGINS,
-	MAX8997_PMICIRQ_CHGRM,
-	MAX8997_PMICIRQ_DCINOVP,
-	MAX8997_PMICIRQ_TOPOFFR,
-	MAX8997_PMICIRQ_CHGRSTF,
-	MAX8997_PMICIRQ_MBCHGTMEXPD,
-
-	MAX8997_PMICIRQ_RTC60S,
-	MAX8997_PMICIRQ_RTCA1,
-	MAX8997_PMICIRQ_RTCA2,
-	MAX8997_PMICIRQ_SMPL_INT,
-	MAX8997_PMICIRQ_RTC1S,
-	MAX8997_PMICIRQ_WTSR,
-
-	MAX8997_MUICIRQ_ADCError,
-	MAX8997_MUICIRQ_ADCLow,
-	MAX8997_MUICIRQ_ADC,
-
-	MAX8997_MUICIRQ_VBVolt,
-	MAX8997_MUICIRQ_DBChg,
-	MAX8997_MUICIRQ_DCDTmr,
-	MAX8997_MUICIRQ_ChgDetRun,
-	MAX8997_MUICIRQ_ChgTyp,
-
-	MAX8997_MUICIRQ_OVP,
-
-	MAX8997_IRQ_NR,
-};
-
 #define MAX8997_NUM_GPIO	12
 struct max8997_dev {
 	struct device *dev;
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 0bbd13d..90e7731 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -119,4 +119,50 @@ struct max8997_platform_data {
 	/* Flash: Not implemented */
 };
 
+enum max8997_irq {
+	MAX8997_PMICIRQ_PWRONR,
+	MAX8997_PMICIRQ_PWRONF,
+	MAX8997_PMICIRQ_PWRON1SEC,
+	MAX8997_PMICIRQ_JIGONR,
+	MAX8997_PMICIRQ_JIGONF,
+	MAX8997_PMICIRQ_LOWBAT2,
+	MAX8997_PMICIRQ_LOWBAT1,
+
+	MAX8997_PMICIRQ_JIGR,
+	MAX8997_PMICIRQ_JIGF,
+	MAX8997_PMICIRQ_MR,
+	MAX8997_PMICIRQ_DVS1OK,
+	MAX8997_PMICIRQ_DVS2OK,
+	MAX8997_PMICIRQ_DVS3OK,
+	MAX8997_PMICIRQ_DVS4OK,
+
+	MAX8997_PMICIRQ_CHGINS,
+	MAX8997_PMICIRQ_CHGRM,
+	MAX8997_PMICIRQ_DCINOVP,
+	MAX8997_PMICIRQ_TOPOFFR,
+	MAX8997_PMICIRQ_CHGRSTF,
+	MAX8997_PMICIRQ_MBCHGTMEXPD,
+
+	MAX8997_PMICIRQ_RTC60S,
+	MAX8997_PMICIRQ_RTCA1,
+	MAX8997_PMICIRQ_RTCA2,
+	MAX8997_PMICIRQ_SMPL_INT,
+	MAX8997_PMICIRQ_RTC1S,
+	MAX8997_PMICIRQ_WTSR,
+
+	MAX8997_MUICIRQ_ADCError,
+	MAX8997_MUICIRQ_ADCLow,
+	MAX8997_MUICIRQ_ADC,
+
+	MAX8997_MUICIRQ_VBVolt,
+	MAX8997_MUICIRQ_DBChg,
+	MAX8997_MUICIRQ_DCDTmr,
+	MAX8997_MUICIRQ_ChgDetRun,
+	MAX8997_MUICIRQ_ChgTyp,
+
+	MAX8997_MUICIRQ_OVP,
+
+	MAX8997_IRQ_NR,
+};
+
 #endif /* __LINUX_MFD_MAX8998_H */
-- 
1.7.4.1


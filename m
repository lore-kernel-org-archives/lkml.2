Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1BKU2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:28:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48311 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1BKU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:28:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74105722"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 3/3] msm: iommu: Enable IOMMU support for MSM8960
Date: Fri, 11 Feb 2011 12:28:18 -0800
Message-Id: <1297456098-3241-3-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow IOMMU to be selected for MSM8960 now that the
platform data has been generalized.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 32b9d1f..997c5bd 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -150,7 +150,7 @@ endmenu

 config MSM_IOMMU
 	bool "MSM IOMMU Support"
-	depends on ARCH_MSM8X60
+	depends on ARCH_MSM8X60 || ARCH_MSM8960
 	select IOMMU_API
 	default n
 	help
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


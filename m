Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1A0AOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:14:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15922 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1A0AOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:14:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71899487"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] msm: Remove broken register definition from trout
Date: Wed, 26 Jan 2011 16:14:23 -0800
Message-Id: <1296087264-9659-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed a register change with the clock cleanup on the MSM7x01 targets.

Change-Id: Ic42234b67f6c15760d74f9efca2932cc739931e4
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index d8d9be5..cec6ed1 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -42,7 +42,6 @@
 static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X00),
-	MSM_DEVICE(GPT),
 	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


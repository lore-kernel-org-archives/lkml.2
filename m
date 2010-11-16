Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0KPVfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:35:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35656 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0KPVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:35:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6169"; a="63100631"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH] msm: 8x60: Add TLMM to the iomap.
Date: Tue, 16 Nov 2010 13:35:05 -0800
Message-Id: <1289943305-10949-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the TLMM block to the iomap for MSM8x60 to make gpio
control registers available.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index d36b610..e27d041 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -107,6 +107,7 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_DEVICE(TMR),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
+	MSM_DEVICE(TLMM),
 };
 
 void __init msm_map_msm8x60_io(void)
-- 
1.7.0.4

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

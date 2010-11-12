Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0KLVuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:50:07 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0KLVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:50:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61777436"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 1/3] msm: sirc: warning fix
Date: Fri, 12 Nov 2010 13:49:51 -0800
Message-Id: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate some unreferenced variables.

arch/arm/mach-msm/sirc.c:43: warning: 'save_type' defined but not used
arch/arm/mach-msm/sirc.c:44: warning: 'save_polarity' defined but not used

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/sirc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-msm/sirc.c b/arch/arm/mach-msm/sirc.c
index b079452..152eefd 100644
--- a/arch/arm/mach-msm/sirc.c
+++ b/arch/arm/mach-msm/sirc.c
@@ -40,9 +40,6 @@ static struct sirc_cascade_regs sirc_reg_table[] = {
 	}
 };
 
-static unsigned int save_type;
-static unsigned int save_polarity;
-
 /* Mask off the given interrupt. Keep the int_enable mask in sync with
    the enable reg, so it can be restored after power collapse. */
 static void sirc_irq_mask(unsigned int irq)
-- 
1.7.3.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

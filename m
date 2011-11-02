Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab1KBSl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:41:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332Ab1KBShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706987"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 14/34] msm: proc_comm: Add CLKCTL_RPC_SRC_REQUEST
Date: Wed,  2 Nov 2011 11:36:11 -0700
Message-Id: <1320258991-22325-15-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

This proc_comm command is used to vote for crystal oscillators on
7x30/8x55 variants.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/proc_comm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/proc_comm.h b/arch/arm/mach-msm/proc_comm.h
index 12da4ca..e2f2d5a 100644
--- a/arch/arm/mach-msm/proc_comm.h
+++ b/arch/arm/mach-msm/proc_comm.h
@@ -137,6 +137,7 @@ enum {
 	PCOM_CLKCTL_RPC_RAIL_DISABLE,
 	PCOM_CLKCTL_RPC_RAIL_CONTROL,
 	PCOM_CLKCTL_RPC_MIN_MSMC1,
+	PCOM_CLKCTL_RPC_SRC_REQUEST,
 	PCOM_NUM_CMDS,
 };
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


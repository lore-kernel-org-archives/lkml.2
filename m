Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965500Ab2JDGln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:41:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50792 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab2JDGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:39:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6854"; a="245504054"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] clk: Document .is_enabled op
Date: Wed,  3 Oct 2012 23:38:53 -0700
Message-Id: <1349332735-20096-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
References: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing kernel-doc for this op.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/clk-provider.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 710c6cb..5a548e3 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -53,6 +53,10 @@ struct clk_hw;
  * @disable:	Disable the clock atomically. Called with enable_lock held.
  * 		This function must not sleep.
  *
+ * @is_enabled:	Queries the hardware to determine if the clock is enabled.
+ * 		This function must not sleep. Optional, if this op is not
+ * 		set then the enable count will be used.
+ *
  * @recalc_rate	Recalculate the rate of this clock, by quering hardware.  The
  * 		parent rate is an input parameter.  It is up to the caller to
  * 		insure that the prepare_mutex is held across this call.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


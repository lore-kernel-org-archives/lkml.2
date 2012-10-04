Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508Ab2JDGlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:41:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50826 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405Ab2JDGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:39:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6854"; a="245504056"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] clk: Fix documentation typos
Date: Wed,  3 Oct 2012 23:38:54 -0700
Message-Id: <1349332735-20096-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
References: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some minor typos in the documentation for the ops structure.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/clk-provider.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5a548e3..0571261 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -57,9 +57,9 @@ struct clk_hw;
  * 		This function must not sleep. Optional, if this op is not
  * 		set then the enable count will be used.
  *
- * @recalc_rate	Recalculate the rate of this clock, by quering hardware.  The
+ * @recalc_rate	Recalculate the rate of this clock, by querying hardware. The
  * 		parent rate is an input parameter.  It is up to the caller to
- * 		insure that the prepare_mutex is held across this call.
+ * 		ensure that the prepare_mutex is held across this call.
  * 		Returns the calculated rate.  Optional, but recommended - if
  * 		this op is not set then clock rate will be initialized to 0.
  *
@@ -93,7 +93,7 @@ struct clk_hw;
  * implementations to split any work between atomic (enable) and sleepable
  * (prepare) contexts.  If enabling a clock requires code that might sleep,
  * this must be done in clk_prepare.  Clock enable code that will never be
- * called in a sleepable context may be implement in clk_enable.
+ * called in a sleepable context may be implemented in clk_enable.
  *
  * Typically, drivers will call clk_prepare when a clock may be needed later
  * (eg. when a device is opened), and clk_enable when the clock is actually
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


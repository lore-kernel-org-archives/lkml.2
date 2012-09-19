Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab2ISHBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:01:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2ISHAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:00:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6839"; a="238452249"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/5] video: msm: Remove useless mach/* includes
Date: Wed, 19 Sep 2012 00:00:42 -0700
Message-Id: <1348038044-1790-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
In-Reply-To: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver doesn't need to use these mach includes so remove
them. This is a necessary step to support a single zImage.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/video/msm/mddi.c   | 3 ---
 drivers/video/msm/mdp.c    | 1 -
 drivers/video/msm/mdp_hw.h | 1 -
 3 files changed, 5 deletions(-)

diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
index b061d70..d43e178 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -26,9 +26,6 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/sched.h>
-#include <mach/msm_iomap.h>
-#include <mach/irqs.h>
-#include <mach/board.h>
 #include <mach/msm_fb.h>
 #include "mddi_hw.h"
 
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index cb2ddf1..752eff7 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -25,7 +25,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 
-#include <mach/msm_iomap.h>
 #include <mach/msm_fb.h>
 #include <linux/platform_device.h>
 #include <linux/export.h>
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index d804774..2a84137 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -15,7 +15,6 @@
 #ifndef _MDP_HW_H_
 #define _MDP_HW_H_
 
-#include <mach/msm_iomap.h>
 #include <mach/msm_fb.h>
 
 struct mdp_info {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


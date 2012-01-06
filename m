Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477Ab2AFTVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:21:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22499 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab2AFTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:21:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6581"; a="152883503"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: vreg is a module and so needs module.h
Date: Fri,  6 Jan 2012 11:21:24 -0800
Message-Id: <1325877684-14095-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM7201 vreg appears to have gotten missed in the module.h
cleanup.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/vreg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/vreg.c b/arch/arm/mach-msm/vreg.c
index a9103bc..bd66ed0 100644
--- a/arch/arm/mach-msm/vreg.c
+++ b/arch/arm/mach-msm/vreg.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <mach/vreg.h>
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


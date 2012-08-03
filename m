Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2HCXDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 19:03:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3983 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2HCXC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 19:02:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6792"; a="219034139"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/TRIVIAL] ARM: Drop duplicate select for GENERIC_IRQ_PROBE
Date: Fri,  3 Aug 2012 16:02:57 -0700
Message-Id: <1344034977-6105-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.rc1.16.g05a20c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that Thomas' and my patches collided during the last merge
window.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e91c7cd..b528d04 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -38,7 +38,6 @@ config ARM
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
-	select GENERIC_IRQ_PROBE
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HARDIRQS_SW_RESEND
 	select CPU_PM if (SUSPEND || CPU_IDLE)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


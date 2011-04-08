Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab1DHWIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:08:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17719 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab1DHWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:08:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6310"; a="84615138"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS
Date: Fri,  8 Apr 2011 15:08:38 -0700
Message-Id: <1302300518-7523-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config option isn't actually used anywhere and can be safely
removed. The last user was traps.c before commit 082f47a ([ARM]
always allow dump_stack() to produce a backtrace, 2007-07-05).

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig.debug |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 494224a..03d01d7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -63,17 +63,6 @@ config DEBUG_USER
 	      8 - SIGSEGV faults
 	     16 - SIGBUS faults
 
-config DEBUG_ERRORS
-	bool "Verbose kernel error messages"
-	depends on DEBUG_KERNEL
-	help
-	  This option controls verbose debugging information which can be
-	  printed when the kernel detects an internal error. This debugging
-	  information is useful to kernel hackers when tracking down problems,
-	  but mostly meaningless to other people. It's safe to say Y unless
-	  you are concerned with the code size or don't want to see these
-	  messages.
-
 config DEBUG_STACK_USAGE
 	bool "Enable stack utilization instrumentation"
 	depends on DEBUG_KERNEL
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


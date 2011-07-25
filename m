Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1GYBPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:15:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59938 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1GYBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:15:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6417"; a="105406998"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] Documentation: Document ARM's user_debug parameter
Date: Sun, 24 Jul 2011 18:15:14 -0700
Message-Id: <1311556514-24728-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.233.gd79bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually kernel parameters are documented in kernel-parameters.txt
but user_debug is only documented in the Kconfig. Document the
option and point to the Kconfig help text for more info.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 Documentation/kernel-parameters.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index aa47be7..8186adc 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2612,6 +2612,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
+	user_debug=	[KNL,ARM]
+			Format: <int>
+			See arch/arm/Kconfig.debug help text.
+				 1 - undefined instruction events
+				 2 - system calls
+				 4 - invalid data aborts
+				 8 - SIGSEGV faults
+				16 - SIGBUS faults
+			Example: user_debug=31
+
 	userpte=
 			[X86] Flags controlling user PTE allocations.
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


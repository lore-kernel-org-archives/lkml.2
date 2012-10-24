Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935425Ab2JXSAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:00:50 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41282 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935262Ab2JXSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:00:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6875"; a="1516503"
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] MAINTAINERS: Add arm-soc tree entry
Date: Wed, 24 Oct 2012 11:00:29 -0700
Message-Id: <1351101629-11826-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the arm-soc tree in the maintainers file so that
developers know how arm SoC development is structured.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 014272b..f70afea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -637,6 +637,13 @@ W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
 
+ARM SUB-ARCHITECTURES
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	MAINTAINED
+F:	arch/arm/mach-*/
+F:	arch/arm/plat-*/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
+
 ARM PRIMECELL AACI PL041 DRIVER
 M:	Russell King <linux@arm.linux.org.uk>
 S:	Maintained
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


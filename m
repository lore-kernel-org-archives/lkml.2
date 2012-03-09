Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2CITjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:39:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39585 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab2CITjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:39:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6644"; a="168803803"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] MAINTAINERS: new git entry for arm/mach-msm
Date: Fri,  9 Mar 2012 11:39:32 -0800
Message-Id: <1331321972-9353-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git tree moved to
git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b087b3bc..3321d75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -962,7 +962,7 @@ F:	drivers/tty/serial/msm_serial.c
 F:	drivers/platform/msm/
 F:	drivers/*/pm8???-*
 F:	include/linux/mfd/pm8xxx/
-T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
 S:	Maintained
 
 ARM/TOSA MACHINE SUPPORT
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


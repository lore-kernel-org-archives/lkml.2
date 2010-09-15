Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0IOLX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:23:59 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54940 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab0IOLX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:23:58 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        <mattias.wallin@stericsson.com>, <srinidhi.kasagar@stericsson.com>,
        <arun.murthy@stericsson.com>
Subject: [PATCH] mfd: ab8500: update kconfig for ab8500 core driver
Date: Wed, 15 Sep 2010 16:53:43 +0530
Message-ID: <1284549823-6246-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a dependancy for ab8500-core driver so as to depend on
u8500 platform.

This patch also fixes the build issues(powerpc_allyesconfig) for the
patch 03f582a93ecca6e9584b622570022abf08ed03ec (misc: Add ab8500 pwm
driver)

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fbfe14a..841ce47 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -475,7 +475,7 @@ config EZX_PCAP
 
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
-	depends on GENERIC_HARDIRQS && ABX500_CORE
+	depends on GENERIC_HARDIRQS && ABX500_CORE && ARCH_U8500
 	select MFD_CORE
 	help
 	  Select this option to enable access to AB8500 power management
-- 
1.7.2.dirty


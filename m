Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599Ab1ETJv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:51:26 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:47485 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935515Ab1ETJvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:51:21 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/3] ARM: mxs: select GPIO_MXS for i.MX23 and i.MX28
Date: Fri, 20 May 2011 17:57:26 +0800
Message-Id: <1305885446-27404-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mxs/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mxs/Kconfig b/arch/arm/mach-mxs/Kconfig
index 21de5d5..afb1b44 100644
--- a/arch/arm/mach-mxs/Kconfig
+++ b/arch/arm/mach-mxs/Kconfig
@@ -8,11 +8,13 @@ config MXS_OCOTP
 config SOC_IMX23
 	bool
 	select CPU_ARM926T
+	select GPIO_MXS
 	select HAVE_PWM
 
 config SOC_IMX28
 	bool
 	select CPU_ARM926T
+	select GPIO_MXS
 	select HAVE_PWM
 
 comment "MXS platforms:"
-- 
1.7.4.1


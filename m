Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2KCWCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:02:52 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36338 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2KCWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/9] ARM: integrator: Remove unused icst_params lclk_params structure
Date: Sat,  3 Nov 2012 23:02:22 +0100
Message-Id: <1351980150-24145-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced way back before 2005 and has remained unused for
over 7 years. Let's remove it.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-integrator/cpu.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
index 590c192..4e0a689 100644
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -30,18 +30,6 @@ static struct cpufreq_driver integrator_driver;
 #define CM_STAT __io_address(INTEGRATOR_HDR_STAT)
 #define CM_LOCK __io_address(INTEGRATOR_HDR_LOCK)
 
-static const struct icst_params lclk_params = {
-	.ref		= 24000000,
-	.vco_max	= ICST525_VCO_MAX_5V,
-	.vco_min	= ICST525_VCO_MIN,
-	.vd_min		= 8,
-	.vd_max		= 132,
-	.rd_min		= 24,
-	.rd_max		= 24,
-	.s2div		= icst525_s2div,
-	.idx2s		= icst525_idx2s,
-};
-
 static const struct icst_params cclk_params = {
 	.ref		= 24000000,
 	.vco_max	= ICST525_VCO_MAX_5V,
-- 
1.7.9.5


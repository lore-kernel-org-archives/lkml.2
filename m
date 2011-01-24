Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1AXCCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:38 -0500
Received: from smtp-out.google.com ([74.125.121.67]:57407 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1AXCCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:09 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 28/28] ARM: tegra: clock: Add forward reference to struct clk
Date: Sun, 23 Jan 2011 18:01:33 -0800
Message-Id: <1295834493-5019-29-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/clk.h    |    2 ++
 arch/arm/mach-tegra/include/mach/clkdev.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index d772395..a217f68 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -20,6 +20,8 @@
 #ifndef __MACH_CLK_H
 #define __MACH_CLK_H
 
+struct clk;
+
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
diff --git a/arch/arm/mach-tegra/include/mach/clkdev.h b/arch/arm/mach-tegra/include/mach/clkdev.h
index 412f5c6..66cd3f4 100644
--- a/arch/arm/mach-tegra/include/mach/clkdev.h
+++ b/arch/arm/mach-tegra/include/mach/clkdev.h
@@ -20,6 +20,8 @@
 #ifndef __MACH_CLKDEV_H
 #define __MACH_CLKDEV_H
 
+struct clk;
+
 static inline int __clk_get(struct clk *clk)
 {
 	return 1;
-- 
1.7.3.1


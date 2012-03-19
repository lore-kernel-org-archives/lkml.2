Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab2CSSdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:33:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40946 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2CSSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:33:14 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/clk: add prompt for menuconfig entry
Date: Mon, 19 Mar 2012 11:33:05 -0700
Message-Id: <1332181985-15209-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building next-20120319 gives the following warning:

drivers/clk/Kconfig:22: warning: menuconfig statement without prompt

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/clk/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 82bcfbd..d857235 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -10,7 +10,7 @@ config HAVE_MACH_CLKDEV
 	bool
 
 menuconfig COMMON_CLK
-	bool
+	bool "Use common clock framework"
 	select HAVE_CLK_PREPARE
 	---help---
 	  The common clock framework is a single definition of struct
-- 
1.7.7.6


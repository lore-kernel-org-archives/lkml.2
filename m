Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2DIUZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:25:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58772 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DIUZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:25:23 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/4] clk: select CLKDEV_LOOKUP for COMMON_CLK
Date: Mon,  9 Apr 2012 15:24:58 -0500
Message-Id: <1334003101-17274-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Using the common clock infrastructure without the common clkdev code makes
little sense, so select CLKDEV_LOOKUP for COMMON_CLK.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/clk/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 165e1fe..f05a60d 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -12,6 +12,7 @@ config HAVE_MACH_CLKDEV
 config COMMON_CLK
 	bool
 	select HAVE_CLK_PREPARE
+	select CLKDEV_LOOKUP
 	---help---
 	  The common clock framework is a single definition of struct
 	  clk, useful across many platforms, as well as an
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2DIUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:25:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58772 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DIUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:25:26 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/4] clk: remove trailing whitespace from clk.h
Date: Mon,  9 Apr 2012 15:24:59 -0500
Message-Id: <1334003101-17274-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove trailing whitespace from 2 lines.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/clk.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index b025272..e08bff1 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -220,7 +220,7 @@ void clk_put(struct clk *clk);
  * Returns rounded clock rate in Hz, or negative errno.
  */
 long clk_round_rate(struct clk *clk, unsigned long rate);
- 
+
 /**
  * clk_set_rate - set the clock rate for a clock source
  * @clk: clock source
@@ -229,7 +229,7 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
  * Returns success (0) or negative errno.
  */
 int clk_set_rate(struct clk *clk, unsigned long rate);
- 
+
 /**
  * clk_set_parent - set the parent clock source for this clock
  * @clk: clock source
-- 
1.7.5.4


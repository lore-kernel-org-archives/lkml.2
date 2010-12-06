Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0LFNV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:21:27 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:49115 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0LFNV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=pwYAgBzpUWvfi70mMLUWwTQuvgfbuFJSroBQW955676qYzcTjIeWczkoV1EEDJfXdY
         jW+MsKcDEZoxJ5fVdNK6K9zosYuQiPnVxQxEF6rzbYk3+klkEPbzwAV2BJQ3vDETJ2K1
         OpvHt2WJ4Kqt4T8ipX1oQtHIDIJczTkGi/Jdc=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] omap1: pm_bus: Fix compilation warning.
Date: Mon,  6 Dec 2010 14:23:48 +0100
Message-Id: <1291641828-19909-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation warning:
arch/arm/mach-omap1/pm_bus.c: In function 'omap1_pm_runtime_resume':
arch/arm/mach-omap1/pm_bus.c:51: warning: unused variable 'ret'

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-omap1/pm_bus.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/pm_bus.c b/arch/arm/mach-omap1/pm_bus.c
index 8b66392..f97c6e9 100644
--- a/arch/arm/mach-omap1/pm_bus.c
+++ b/arch/arm/mach-omap1/pm_bus.c
@@ -48,7 +48,6 @@ static int omap1_pm_runtime_suspend(struct device *dev)
 
 static int omap1_pm_runtime_resume(struct device *dev)
 {
-	int ret = 0;
 	struct clk *iclk, *fclk;
 
 	dev_dbg(dev, "%s\n", __func__);
-- 
1.7.1


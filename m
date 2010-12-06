Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0LFNDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:03:53 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:59863 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0LFNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=LeIPXRAeFEc6ggNXvQL1JUBfeMThQif2qANLayzY35IthROcBQQoHPXJGC9dppKs/9
         bVpwZyTlSu8mST0nr+tPcp8Cc1GwJLFleERaz5BUwXU2kSQGWLchVT7AC/5P8A79MY+F
         /zGS679pgz7r6DaFCFwkCrV/5tZZswL8NZML4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: tony@atomide.com
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] omap1: htc_herald: Fix compilation warning.
Date: Mon,  6 Dec 2010 13:49:05 +0100
Message-Id: <1291639745-17320-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fix following compilation warning:
arch/arm/mach-omap1/board-htcherald.c:442:
warning: large integer implicitly truncated to unsigned type

Hopefully this is just a typo.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-omap1/board-htcherald.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/board-htcherald.c b/arch/arm/mach-omap1/board-htcherald.c
index 071af3e..cdbf3b1 100644
--- a/arch/arm/mach-omap1/board-htcherald.c
+++ b/arch/arm/mach-omap1/board-htcherald.c
@@ -439,7 +439,7 @@ static const struct ads7846_platform_data htcherald_ts_platform_data = {
 	.keep_vref_on		= 1,
 	.x_plate_ohms		= 496,
 	.gpio_pendown		= HTCHERALD_GPIO_TS,
-	.pressure_max		= 100000,
+	.pressure_max		= 10000,
 	.pressure_min		= 5000,
 	.x_min			= 528,
 	.x_max			= 3760,
-- 
1.7.1


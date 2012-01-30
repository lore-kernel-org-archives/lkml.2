Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2A3QCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:02:55 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:55650 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367Ab2A3QCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:02:54 -0500
From: Roland Stigge <stigge@antcom.de>
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 1/7] LPC32xx: clock.c: Missing header file
Date: Mon, 30 Jan 2012 17:02:00 +0100
Message-Id: <1327939327-7799-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the compiler warnings regarding the EXPORT_SYMBOL usage

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index 1e02751..8e79313 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -82,6 +82,7 @@
  *   will also impact the individual peripheral rates.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/errno.h>

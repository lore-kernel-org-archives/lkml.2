Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2GRMHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:07:35 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:50170 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260Ab2GRMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:07:31 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/4] ARM: LPC32xx: Add PWM support
Date: Wed, 18 Jul 2012 14:06:50 +0200
Message-Id: <1342613211-13190-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342613211-13190-1-git-send-email-stigge@antcom.de>
References: <1342613211-13190-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

This SoC has two PWM channels

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -567,6 +567,7 @@ config ARCH_LPC32XX
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select USE_OF
+	select HAVE_PWM
 	help
 	  Support for the NXP LPC32XX family of processors
 

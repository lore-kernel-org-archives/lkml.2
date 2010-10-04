Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0JDSkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:40:51 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:57817 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab0JDSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:40:49 -0400
Date: Mon, 4 Oct 2010 20:38:42 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video/omap: remove mux.h include
Message-ID: <20101004203842.088b0cb2@absol.kitzblitz>
In-Reply-To: <20101004175429.GW3117@atomide.com>
References: <20101004174344.21577085@absol.kitzblitz>
	<20101004175429.GW3117@atomide.com>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including mux.h should no longer be needed for omap2/3/4 SoCs
outside arch/arm/mach-omap2 files.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/video/omap/lcd_omap3beagle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap/lcd_omap3beagle.c b/drivers/video/omap/lcd_omap3beagle.c
index ca75cc2..d7c6c3e 100644
--- a/drivers/video/omap/lcd_omap3beagle.c
+++ b/drivers/video/omap/lcd_omap3beagle.c
@@ -25,8 +25,6 @@
 #include <linux/gpio.h>
 #include <linux/i2c/twl.h>
 
-#include <plat/mux.h>
-#include <plat/mux.h>
 #include <asm/mach-types.h>
 
 #include "omapfb.h"
-- 
1.7.2.2

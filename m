Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0JDKrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:47:14 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:36990 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088Ab0JDKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:47:13 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 06:47:12 EDT
X-ClientAddr: 91.119.0.188
Date: Mon, 4 Oct 2010 12:39:37 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] arm/omap: remove duplicated include
Message-ID: <20101004123937.4493b01b@absol.kitzblitz>
In-Reply-To: <20101004122436.7092868f@absol.kitzblitz>
References: <20101004122436.7092868f@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o94AXLMQ020440
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/mach-omap2/board-cm-t35.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index e10bc10..3308119 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -237,8 +237,6 @@ static inline void cm_t35_init_nand(void) {}
 	defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
 #include <linux/spi/ads7846.h>
 
-#include <plat/mcspi.h>
-
 static struct omap2_mcspi_device_config ads7846_mcspi_config = {
 	.turbo_mode	= 0,
 	.single_channel	= 1,	/* 0: slave, 1: master */
-- 
1.7.2.2

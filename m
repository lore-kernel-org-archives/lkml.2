Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0F3QA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:00:29 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39967 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0F3QA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:00:26 -0400
Date: Wed, 30 Jun 2010 18:00:23 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, Kalle Valo <kalle.valo@iki.fi>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Ladislav Michl <ladis@linux-mips.org>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 20/33] Removing dead MACH_OMAP2_H4_USB1
Message-ID: <24b01f2edebd09e37306c35f14401819d8219549.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MACH_OMAP2_H4_USB1 doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap2/board-h4.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index 85d7fb8..f0c2701 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -272,11 +272,6 @@ static struct omap_lcd_config h4_lcd_config __initdata = {
 };
 
 static struct omap_usb_config h4_usb_config __initdata = {
-#ifdef	CONFIG_MACH_OMAP2_H4_USB1
-	/* NOTE:  usb1 could also be used with 3 wire signaling */
-	.pins[1]	= 4,
-#endif
-
 	/* S1.10 OFF -- usb "download port"
 	 * usb0 switched to Mini-B port and isp1105 transceiver;
 	 * S2.POS3 = ON, S2.POS4 = OFF ... to enable battery charging
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab1LPTy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:54:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964872Ab1LPTwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:52:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:07 2011
Message-Id: <20111216194207.688211906@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [06/45] ARM: at91: fix clock conid for atmel_tcb.1 on 9260/9g20
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 1808958d27b1250295f01dff4997d8a8814adaab upstream.

The conid is supposed to be t0/t1/t2_clk.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-at91/at91sam9260.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -237,9 +237,9 @@ static struct clk_lookup periph_clocks_l
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
 	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.0", &tc1_clk),
 	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.0", &tc2_clk),
-	CLKDEV_CON_DEV_ID("t3_clk", "atmel_tcb.1", &tc3_clk),
-	CLKDEV_CON_DEV_ID("t4_clk", "atmel_tcb.1", &tc4_clk),
-	CLKDEV_CON_DEV_ID("t5_clk", "atmel_tcb.1", &tc5_clk),
+	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tc3_clk),
+	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.1", &tc4_clk),
+	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.1", &tc5_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc_clk),
 };
 



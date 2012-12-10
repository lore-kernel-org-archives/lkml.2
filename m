Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2LJKWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:22:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59248 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2LJKV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: [PATCH v4 22/23] ARM: OMAP4: clock data: get rid of unused USB host clock aliases
Date: Mon, 10 Dec 2012 12:20:32 +0200
Message-ID: <1355134833-5199-23-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need multiple aliases for the OMAP USB host clocks so remove them.

CC: Paul Walmsley <paul@pwsan.com>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Benoit Cousson <b-cousson@ti.com>
CC: Mike Turquette <mturquette@gmail.com>

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/cclock44xx_data.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 74535fe..5a27244 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -1858,7 +1858,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart3_fck",			&uart3_fck,	CK_443X),
 	CLK(NULL,	"uart4_fck",			&uart4_fck,	CK_443X),
 	CLK(NULL,	"usb_host_fs_fck",		&usb_host_fs_fck,	CK_443X),
-	CLK("usbhs_omap",	"fs_fck",		&usb_host_fs_fck,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&usb_host_hs_utmi_p1_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p2_clk",	&usb_host_hs_utmi_p2_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p3_clk",	&usb_host_hs_utmi_p3_clk,	CK_443X),
@@ -1868,7 +1867,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"usb_host_hs_hsic480m_p2_clk",	&usb_host_hs_hsic480m_p2_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_func48mclk",	&usb_host_hs_func48mclk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_fck",		&usb_host_hs_fck,	CK_443X),
-	CLK("usbhs_omap",	"hs_fck",		&usb_host_hs_fck,	CK_443X),
 	CLK(NULL,	"otg_60m_gfclk",		&otg_60m_gfclk,	CK_443X),
 	CLK(NULL,	"usb_otg_hs_xclk",		&usb_otg_hs_xclk,	CK_443X),
 	CLK(NULL,	"usb_otg_hs_ick",		&usb_otg_hs_ick,	CK_443X),
@@ -1878,8 +1876,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"usb_tll_hs_usb_ch0_clk",	&usb_tll_hs_usb_ch0_clk,	CK_443X),
 	CLK(NULL,	"usb_tll_hs_usb_ch1_clk",	&usb_tll_hs_usb_ch1_clk,	CK_443X),
 	CLK(NULL,	"usb_tll_hs_ick",		&usb_tll_hs_ick,	CK_443X),
-	CLK("usbhs_omap",	"usbtll_ick",		&usb_tll_hs_ick,	CK_443X),
-	CLK("usbhs_tll",	"usbtll_ick",		&usb_tll_hs_ick,	CK_443X),
 	CLK(NULL,	"usim_ck",			&usim_ck,	CK_443X),
 	CLK(NULL,	"usim_fclk",			&usim_fclk,	CK_443X),
 	CLK(NULL,	"usim_fck",			&usim_fck,	CK_443X),
@@ -1930,9 +1926,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart2_ick",			&dummy_ck,	CK_443X),
 	CLK(NULL,	"uart3_ick",			&dummy_ck,	CK_443X),
 	CLK(NULL,	"uart4_ick",			&dummy_ck,	CK_443X),
-	CLK("usbhs_omap",	"usbhost_ick",		&dummy_ck,		CK_443X),
-	CLK("usbhs_omap",	"usbtll_fck",		&dummy_ck,	CK_443X),
-	CLK("usbhs_tll",	"usbtll_fck",		&dummy_ck,	CK_443X),
+	CLK(NULL,	"usbhost_ick",			&dummy_ck,	CK_443X),
 	CLK("omap_wdt",	"ick",				&dummy_ck,	CK_443X),
 	CLK(NULL,	"timer_32k_ck",	&sys_32k_ck,	CK_443X),
 	/* TODO: Remove "omap_timer.X" aliases once DT migration is complete */
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0E1LnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:43:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56426 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab0E1Lmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:42:45 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: sha@pengutronix.de
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mx35: adjust flexcan clock definition
Date: Fri, 28 May 2010 13:42:17 +0200
Message-Id: <1275046938-8465-4-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
References: <1275046938-8465-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 arch/arm/mach-mx3/clock-imx35.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mx3/clock-imx35.c b/arch/arm/mach-mx3/clock-imx35.c
index 9f3e943..ba4e722 100644
--- a/arch/arm/mach-mx3/clock-imx35.c
+++ b/arch/arm/mach-mx3/clock-imx35.c
@@ -428,8 +428,8 @@ static struct clk nfc_clk = {
 static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK(NULL, "asrc", asrc_clk)
 	_REGISTER_CLOCK(NULL, "ata", ata_clk)
-	_REGISTER_CLOCK(NULL, "can", can1_clk)
-	_REGISTER_CLOCK(NULL, "can", can2_clk)
+	_REGISTER_CLOCK("flexcan.0", NULL, can1_clk)
+	_REGISTER_CLOCK("flexcan.1", NULL, can2_clk)
 	_REGISTER_CLOCK("spi_imx.0", NULL, cspi1_clk)
 	_REGISTER_CLOCK("spi_imx.1", NULL, cspi2_clk)
 	_REGISTER_CLOCK(NULL, "ect", ect_clk)
-- 
1.7.1


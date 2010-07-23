Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab0GWT7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:59:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43181 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292Ab0GWT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:59:35 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Kalle Valo <kalle.valo@iki.fi>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] ARM: omap: ams-delta: move config to .init.data
Date: Fri, 23 Jul 2010 21:58:34 +0200
Message-Id: <1279915120-4373-11-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most other boards have their config in .init.data, too, so this should
be OK.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-omap1/board-ams-delta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index fdd1dd5..6b936cc 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -173,7 +173,7 @@ static struct omap_usb_config ams_delta_usb_config __initdata = {
 	.pins[0]	= 2,
 };
 
-static struct omap_board_config_kernel ams_delta_config[] = {
+static struct omap_board_config_kernel ams_delta_config[] __initdata = {
 	{ OMAP_TAG_LCD,		&ams_delta_lcd_config },
 };
 
-- 
1.7.1


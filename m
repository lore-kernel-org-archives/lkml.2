Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1BIKIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:08:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46677 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1BIKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:08:02 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] trivial: fix typos concerning "registration"
Date: Wed,  9 Feb 2011 11:07:41 +0100
Message-Id: <1297246062-23777-9-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-s5pv210/mach-goni.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index e22d511..c18bd42 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -824,14 +824,14 @@ static void __init goni_map_io(void)
 
 static void __init goni_machine_init(void)
 {
-	/* Radio: call before I2C 1 registeration */
+	/* Radio: call before I2C 1 registration */
 	goni_radio_init();
 
 	/* I2C1 */
 	s3c_i2c1_set_platdata(NULL);
 	i2c_register_board_info(1, i2c1_devs, ARRAY_SIZE(i2c1_devs));
 
-	/* TSP: call before I2C 2 registeration */
+	/* TSP: call before I2C 2 registration */
 	goni_tsp_init();
 
 	/* I2C2 */
-- 
1.7.2.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2GLKLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:11:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623Ab2GLKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:11 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Subject: [PATCH 4/7] rtc/mc13xxx: add support for the rtc in the mc34708 pmic
Date: Thu, 12 Jul 2012 11:57:50 +0200
Message-Id: <1342087073-3892-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-mc13xxx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 0ce0602..2643d88 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -404,6 +404,8 @@ static const struct platform_device_id mc13xxx_rtc_idtable[] = {
 		.name = "mc13783-rtc",
 	}, {
 		.name = "mc13892-rtc",
+	}, {
+		.name = "mc34708-rtc",
 	},
 	{ /* sentinel */ }
 };
-- 
1.7.10.4


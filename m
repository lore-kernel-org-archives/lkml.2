Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0I2QYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:24:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41386 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0I2QYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:24:04 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH 2/4] mfd/mc13783: remove deprecated functions
Date: Wed, 29 Sep 2010 18:23:45 +0200
Message-Id: <1285777427-2887-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20100929162315.GG29811@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de>
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

The last user is gone since v2.6.34-rc1~40

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 include/linux/mfd/mc13783.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 0fa44fb..5f6aff5 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -35,24 +35,6 @@ int mc13783_irq_status(struct mc13783 *mc13783, int irq,
 		int *enabled, int *pending);
 int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
 
-static inline int mc13783_mask(struct mc13783 *mc13783, int irq) __deprecated;
-static inline int mc13783_mask(struct mc13783 *mc13783, int irq)
-{
-	return mc13783_irq_mask(mc13783, irq);
-}
-
-static inline int mc13783_unmask(struct mc13783 *mc13783, int irq) __deprecated;
-static inline int mc13783_unmask(struct mc13783 *mc13783, int irq)
-{
-	return mc13783_irq_unmask(mc13783, irq);
-}
-
-static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq) __deprecated;
-static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq)
-{
-	return mc13783_irq_ack(mc13783, irq);
-}
-
 #define MC13783_ADC0		43
 #define MC13783_ADC0_ADREFEN		(1 << 10)
 #define MC13783_ADC0_ADREFMODE		(1 << 11)
-- 
1.7.2.3


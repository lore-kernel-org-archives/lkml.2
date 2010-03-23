Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab0CWKZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:25:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60841 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0CWKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:25:00 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] gpiolib: a gpio is unsigned, so use %u to print it
Date: Tue, 23 Mar 2010 11:24:54 +0100
Message-Id: <1269339895-12600-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100322204706.GA10157@pengutronix.de>
References: <20100322204706.GA10157@pengutronix.de>
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
 drivers/gpio/gpiolib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 03e82d5..548b71e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -751,7 +751,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		struct device	*dev;
 
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-				desc, ioname ? ioname : "gpio%d", gpio);
+				desc, ioname ? ioname : "gpio%u", gpio);
 		if (!IS_ERR(dev)) {
 			status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
-- 
1.7.0


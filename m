Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1HIQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:37:34 -0400
Received: from relay.ptn-ipout01.plus.net ([212.159.7.35]:22613 "EHLO
	relay.ptn-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab1HIQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:37:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8lALteQU5UXebj/2dsb2JhbABCgh2CbJJmNY8ad4FuUnE1GBOHb615AodTiS0OhjgEmA6DLoE4hnw
Subject: [PATCH] mfd: asic3: Define gpio_chip label
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <philipp.zabel@gmail.com>, <sameo@linux.intel.com>, <mad_soft@inbox.ru>,
        <koen@dominion.thruhere.net>
Date: Tue, 09 Aug 2011 16:27:50 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.39 x86_64 [http://email.cleancode.org])
Message-Id: <E1Qqp9k-00013y-Fo@outmx01.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defined the gpio_chip label in the mfd/asic3 driver for diagnostics.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---

diff -uprN clean-3.0.1/drivers/mfd/asic3.c linux-3.0.1/drivers/mfd/asic3.c
--- clean-3.0.1/drivers/mfd/asic3.c	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1/drivers/mfd/asic3.c	2011-08-08 11:22:58.935625761 +0100
@@ -949,6 +949,7 @@ static int __init asic3_probe(struct pla
 		goto out_unmap;
 	}
 
+	asic->gpio.label = "asic3";
 	asic->gpio.base = pdata->gpio_base;
 	asic->gpio.ngpio = ASIC3_NUM_GPIOS;
 	asic->gpio.get = asic3_gpio_get;


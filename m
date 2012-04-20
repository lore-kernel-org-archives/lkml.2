Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2DTPIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:08:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38113 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab2DTPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:08:27 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] devicetree: bindings: gpio-i2c belongs to i2c not gpio
Date: Fri, 20 Apr 2012 17:08:02 +0200
Message-Id: <1334934487-19201-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.9.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio-i2c describes an I2C controller (using gpios for data and clock),
so it must be described in i2c, not gpio.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 .../{gpio/gpio_i2c.txt => i2c/gpio-i2c.txt}        |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/{gpio/gpio_i2c.txt => i2c/gpio-i2c.txt} (100%)

diff --git a/Documentation/devicetree/bindings/gpio/gpio_i2c.txt b/Documentation/devicetree/bindings/i2c/gpio-i2c.txt
similarity index 100%
rename from Documentation/devicetree/bindings/gpio/gpio_i2c.txt
rename to Documentation/devicetree/bindings/i2c/gpio-i2c.txt
-- 
1.7.9.5


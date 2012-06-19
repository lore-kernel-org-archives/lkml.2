Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab2FSHHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:07:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37716 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab2FSHHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:07:43 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: add EXPORT_SYMBOL() for devm_gpio_request_one
Thread-Topic: [PATCH] gpio: add EXPORT_SYMBOL() for devm_gpio_request_one
Thread-Index: Ac1N6jIXz2GfX+sQTTq8b0EPu/tYxg==
Date: Tue, 19 Jun 2012 07:07:35 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FB8B9@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_gpio_request_one() can be used by dynamically loaded modules,
so it should be exported.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/gpio/devres.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 9e9947c..1077754 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -98,6 +98,7 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 
 	return 0;
 }
+EXPORT_SYMBOL(devm_gpio_request_one);
 
 /**
  *      devm_gpio_free - free an interrupt
-- 
1.7.2.5


Best Regards,
Milo (Woogyom) Kim




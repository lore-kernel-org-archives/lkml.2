Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1GFCIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 22:08:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50322 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1GFCIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 22:08:36 -0400
Subject: [PATCH] gpio: tps65910: add missing breaks in tps65910_gpio_init
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Jorge Eduardo Candelaria jedu"@slimlogic.co.uk,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 10:08:27 +0800
Message-ID: <1309918107.26847.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-tps65910.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index 4171033..b9c1c29 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -81,8 +81,10 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
 	switch(tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->gpio.ngpio	= 6;
+		break;
 	case TPS65911:
 		tps65910->gpio.ngpio	= 9;
+		break;
 	default:
 		return;
 	}
-- 
1.7.4.1




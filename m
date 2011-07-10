Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1GJJ3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:29:50 -0400
Received: from mail.perches.com ([173.55.12.10]:3722 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab1GJJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:28:33 -0400
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] gpio-tps65910.c: Add missing breaks in switch/case
Date: Sun, 10 Jul 2011 02:28:24 -0700
Message-Id: <7e14caefe46d21a949efd9daeda3e43cb13eef45.1310289795.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
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
1.7.6.131.g99019


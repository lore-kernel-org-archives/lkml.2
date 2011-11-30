Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab1K3MFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:05:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62217 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1K3MFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:05:01 -0500
Message-ID: <1322654694.11191.2.camel@phoenix>
Subject: [PATCH] leds: lp5523: remove unneeded forward declaration
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 30 Nov 2011 20:04:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lp5523.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 0170760..73e791a 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -870,8 +870,6 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 	return 0;
 }
 
-static struct i2c_driver lp5523_driver;
-
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-- 
1.7.5.4




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2BHIbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 03:31:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38957 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab2BHIbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 03:31:02 -0500
Message-ID: <1328689851.2320.0.camel@phoenix>
Subject: [PATCH] leds/leds-pca9633.c: remove unused 'adapter' variable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 08 Feb 2012 16:30:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-pca9633.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
index c408ddc..02889bb 100644
--- a/drivers/leds/leds-pca9633.c
+++ b/drivers/leds/leds-pca9633.c
@@ -96,11 +96,9 @@ static int __devinit pca9633_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct pca9633_led *pca9633;
-	struct i2c_adapter *adapter;
 	struct led_platform_data *pdata;
 	int i, err;
 
-	adapter = to_i2c_adapter(client->dev.parent);
 	pdata = client->dev.platform_data;
 
 	if (pdata) {
-- 
1.7.5.4




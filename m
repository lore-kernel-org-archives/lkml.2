Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1HYKas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:30:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46324 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1HYKaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:30:46 -0400
Subject: [PATCH] Input: adp5588-keys - remove incorrect modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        device-drivers-devel@blackfin.uclinux.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 18:30:38 +0800
Message-ID: <1314268238.2663.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b642fd34e59291764f5149f083d84760d8b41b2 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 25 Aug 2011 18:26:56 +0800
Subject: [PATCH] Input: adp5588-keys - remove incorrect modalias

For i2c drivers, we should use "i2c:" prefix for modalias.
MODULE_DEVICE_TABLE will setup the modulalias for us,
thus adding a MODULE_ALIAS here seems redundant.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/adp5588-keys.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 7b404e54..e34eeb8 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -668,4 +668,3 @@ module_exit(adp5588_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP5588/87 Keypad driver");
-MODULE_ALIAS("platform:adp5588-keys");
-- 
1.7.4.1




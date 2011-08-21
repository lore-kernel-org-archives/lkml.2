Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1HUIvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 04:51:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49535 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1HUIvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 04:51:00 -0400
Subject: [PATCH] Input: ep93xx_keypad - add missing include of
 linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 16:50:53 +0800
Message-ID: <1313916653.17491.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep93xx_keypad.c uses interfaces from linux/module.h,
so it should include that file.  This patch fixes build errors.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/ep93xx_keypad.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index c8242dd..aa17e02 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -20,6 +20,7 @@
  * flag.
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
-- 
1.7.4.1




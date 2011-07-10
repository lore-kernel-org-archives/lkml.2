Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1GJHpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 03:45:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51988 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1GJHpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 03:45:17 -0400
Subject: [PATCH] gpio: wm831x: add a missing break in wm831x_gpio_dbg_show
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 15:45:07 +0800
Message-ID: <1310283907.2774.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-wm831x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-wm831x.c b/drivers/gpio/gpio-wm831x.c
index 31a9ed7..deb949e 100644
--- a/drivers/gpio/gpio-wm831x.c
+++ b/drivers/gpio/gpio-wm831x.c
@@ -180,6 +180,7 @@ static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			break;
 		case WM831X_GPIO_PULL_UP:
 			pull = "pullup";
+			break;
 		default:
 			pull = "INVALID PULL";
 			break;
-- 
1.7.4.1




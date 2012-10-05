Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2JEHPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:15:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JEHPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:15:50 -0400
From: Daniel J Blueman <daniel@quora.org>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "Ben Dooks" <ben-linux@fluff.org>, "Wolfram Sang" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Fix Intel PIIX4 I2C driver build failure
Date: Fri,  5 Oct 2012 12:21:11 +0800
Message-Id: <1349410871-17140-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure in Intel PIIX4 I2C driver.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/i2c/busses/i2c-piix4.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index ef511df..8bbd6ec 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -37,6 +37,7 @@
 #include <linux/stddef.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/acpi.h>
-- 
1.7.9.5


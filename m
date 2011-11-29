Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1K2CIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 21:08:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59440 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1K2CIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 21:08:04 -0500
Message-ID: <1322532472.3213.0.camel@phoenix>
Subject: [PATCH 1/2] Input: ad7879-i2c - remove redundant MODULE_ALIAS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Tue, 29 Nov 2011 10:07:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MODULE_DEVICE_TABLE will setup the module alias for us, thus adding
MODULE_ALIAS for an entry already in MODULE_DEVICE_TABLE is redundant.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/ad7879-i2c.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/ad7879-i2c.c b/drivers/input/touchscreen/ad7879-i2c.c
index c4b5117..b746702 100644
--- a/drivers/input/touchscreen/ad7879-i2c.c
+++ b/drivers/input/touchscreen/ad7879-i2c.c
@@ -117,4 +117,3 @@ module_exit(ad7879_i2c_exit);
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7879(-1) touchscreen I2C bus driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("i2c:ad7879");
-- 
1.7.5.4




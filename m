Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1JQTjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:39:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55024 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1JQTjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:39:42 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: michael.hennerich@analog.com, vapier@gentoo.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] ad525x_dpot: add i2c support for AD5161
Date: Mon, 17 Oct 2011 21:39:36 +0200
Message-Id: <1318880376-1310-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6c536e4ce8e (ad525x_dpot: add support for SPI parts) added support
for the AD5161 through SPI, but the device supports both I2C and SPI
(depending on the DIS pin), so add it to -i2c as well.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/misc/ad525x_dpot-i2c.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index 4ff73c2..a39e055 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -98,6 +98,7 @@ static const struct i2c_device_id ad_dpot_id[] = {
 	{"ad5282", AD5282_ID},
 	{"adn2860", ADN2860_ID},
 	{"ad5273", AD5273_ID},
+	{"ad5161", AD5161_ID},
 	{"ad5171", AD5171_ID},
 	{"ad5170", AD5170_ID},
 	{"ad5172", AD5172_ID},
-- 
1.7.6.3


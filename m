Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2APFsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:48:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40629 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2APFsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:48:31 -0500
Message-ID: <1326692900.12796.0.camel@phoenix>
Subject: [PATCH] power_supply: lp8727_charger: Add terminating entry for
 i2c_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Mon, 16 Jan 2012 13:48:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/lp8727_charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..c53dd12 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -464,6 +464,7 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 
 static const struct i2c_device_id lp8727_ids[] = {
 	{"lp8727", 0},
+	{ }
 };
 
 static struct i2c_driver lp8727_driver = {
-- 
1.7.5.4




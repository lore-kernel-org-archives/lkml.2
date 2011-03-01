Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1CAJTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:19:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50482 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1CAJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HYKBAYwDQXQtuuAv6/j7XYrab7PkMT4lb9y+KQrfk8YlHhgRk8bG+4+ZxEgvGH5wMZ
         MFz0AgWEvFcTFiAYhlYiyEfJeidnN/1bKGPn7j5z3kK6vY2nwjl+5dXgTWqCgNiFTha8
         lZAKhKIwomaLtgOAvCtOlOwpaNoc8ARzhU0w4=
Subject: [PATCH 2/3] power: ds2782_battery: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
In-Reply-To: <1298971353.17825.1.camel@mola>
References: <1298971353.17825.1.camel@mola>
Content-Type: text/plain
Date: Tue, 01 Mar 2011 17:23:34 +0800
Message-Id: <1298971414.17825.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding the MODULE_DEVICE_TABLE, below entries will be added to
modules.alias:
alias i2c:ds2786 ds2782_battery
alias i2c:ds2782 ds2782_battery

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/ds2782_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 6957e8a..4d2dc4f 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -393,6 +393,7 @@ static const struct i2c_device_id ds278x_id[] = {
 	{"ds2786", DS2786},
 	{},
 };
+MODULE_DEVICE_TABLE(i2c, ds278x_id);
 
 static struct i2c_driver ds278x_battery_driver = {
 	.driver 	= {
-- 
1.7.2




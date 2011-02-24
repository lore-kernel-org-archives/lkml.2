Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1BXCSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:18:45 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64951 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1BXCSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bxNM1FhwTEksYH2pevOMQBH7GdQ+0vSuM6fnrtcbeGdATWPlgWMToM1WI3mcrjYanC
         bJPiZ0WACheZuXoDI/lkKqYhVVZyhWNCfc6YEj8RrBnRrhxHqkNcgM9E8Yy3A434y7y2
         Au/aCVYmq1mFUjGnKqUvXzNXAtaSHdx+XZAWE=
Subject: [PATCH 2/2] hwmon: adt7411: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
In-Reply-To: <1298514037.19027.3.camel@mola>
References: <1298514037.19027.3.camel@mola>
Content-Type: text/plain
Date: Thu, 24 Feb 2011 10:22:01 +0800
Message-Id: <1298514121.19027.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/adt7411.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index f13c843..5cc3e37 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -334,6 +334,7 @@ static const struct i2c_device_id adt7411_id[] = {
 	{ "adt7411", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, adt7411_id);
 
 static struct i2c_driver adt7411_driver = {
 	.driver		= {
-- 
1.7.2




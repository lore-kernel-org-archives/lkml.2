Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1BXCRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:17:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1BXCRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jDk3R2ruoRFuBgTdpzw8hl0m3vgSqVOuhzvw4acgsezxUiSun7znBU6Dh2cNeKMUCb
         swZxSZzFJapbNhhOUQMAAG1dQgwu7efpHovb5A1BLhWyj9x4HN0YxjmqdeNbpIdtnc54
         JLmyJMBLfMrnD/dBt4VeMcPcrMa2Pee+dgVT0=
Subject: [PATCH 1/2] hwmon: ad7414: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sean MacLennan <smaclennan@pikatech.com>,
        Frank Edelhaeuser <frank.edelhaeuser@spansion.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Content-Type: text/plain
Date: Thu, 24 Feb 2011 10:20:37 +0800
Message-Id: <1298514037.19027.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/ad7414.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index 86d822a..d46c0c7 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -242,6 +242,7 @@ static const struct i2c_device_id ad7414_id[] = {
 	{ "ad7414", 0 },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, ad7414_id);
 
 static struct i2c_driver ad7414_driver = {
 	.driver = {
-- 
1.7.2




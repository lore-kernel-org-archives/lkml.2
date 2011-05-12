Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1ELKqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:46:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48548 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab1ELKqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hWlgKU3MctJEa0HH0f9gERhpA8UqEA+MeNX2Z9Rn9u4aUeGQdkaKP18BTLtPCqb16H
         N/uA9OYLTmmgm3rBRbXaFMbxKYvNYLubh32EnItON21a1fmJLPODpgHktFl9aZZ6fUo+
         Es97XoZeCGafi2YPtuc1HwXdPK1NSNAFSgy7Y=
Subject: [PATCH] leds: leds-lm3530: Add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 18:46:31 +0800
Message-ID: <1305197191.2570.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the necessary MODULE_DEVICE_TABLE() information allows the
driver to be automatically loaded by udev.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lm3530.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index e7089a1..b37e618 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -349,6 +349,7 @@ static const struct i2c_device_id lm3530_id[] = {
 	{LM3530_NAME, 0},
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, lm3530_id);
 
 static struct i2c_driver lm3530_i2c_driver = {
 	.probe = lm3530_probe,
-- 
1.7.1




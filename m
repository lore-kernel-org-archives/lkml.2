Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab1GJXaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:30:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49148 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1GJXap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:30:45 -0400
Subject: [PATCH] drivers/video/backlight/adp8860_bl.c: remove a redundant
 assignment for max_brightness
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 07:30:34 +0800
Message-ID: <1310340634.2405.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have set props.max_brightness before registering backlight device.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/adp8860_bl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 24a6dfd..66bc74d 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -721,8 +721,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 		goto out2;
 	}
 
-	bl->props.max_brightness =
-		bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
+	bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
 
 	data->bl = bl;
 
-- 
1.7.4.1




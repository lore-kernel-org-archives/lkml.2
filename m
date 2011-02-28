Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1B1GLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:11:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65404 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1B1GLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hY+aK/2KZjKqgsK0jR/oapaB5J5zqOgVaOCslHk2OvC9o+OJgaks6SYS87smljTbvG
         Ykqo3olv2V+Lg99U0CYyqxwJbxnm2ba4GYoZUgMnxgce6tccpEUGB+BZlgecttvD2R9S
         PX4senA4V1RlO4ABckuOv62/+WA/HDNDL9oY0=
Subject: [PATCH] misc: bmp085: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Mair <christoph.mair@gmail.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Feb 2011 14:15:19 +0800
Message-Id: <1298873719.5562.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/bmp085.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 63ee4c1..b6e1c9a 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -449,6 +449,7 @@ static const struct i2c_device_id bmp085_id[] = {
 	{ "bmp085", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, bmp085_id);
 
 static struct i2c_driver bmp085_driver = {
 	.driver = {
-- 
1.7.2




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1LTNAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:00:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45042 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1LTNAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:00:38 -0500
Subject: [PATCH] staging: asus_oled: Fixed checkpatch.pl warnings in
 asus_oled.c
From: Toon Schoenmakers <nighteyes1993@gmail.com>
To: sjakub@gmail.com, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 14:00:33 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324386035.27425.2.camel@RainbowDash>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ac6a96cdf890714ec7b8f0e6597f82a49cfbe232 Mon Sep 17 00:00:00 2001
From: Toon Schoenmakers <nighteyes1993@gmail.com>
Date: Tue, 20 Dec 2011 13:52:41 +0100
Subject: [PATCH] staging: asus_oled: Fixed checkpatch.pl warnings in
asus_oled.c

Signed-off-by: Toon Schoenmakers <nighteyes1993@gmail.com>
---
drivers/staging/asus_oled/asus_oled.c |    4 ++--
1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c
b/drivers/staging/asus_oled/asus_oled.c
index 7bb7da7..e77e4e0 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -201,7 +201,7 @@ static ssize_t set_enabled(struct device *dev,
struct device_attribute *attr,
struct usb_interface *intf = to_usb_interface(dev);
struct asus_oled_dev *odev = usb_get_intfdata(intf);
unsigned long value;
- if (strict_strtoul(buf, 10, &value))
+ if (kstrtoul(buf, 10, &value))
return -EINVAL;

enable_oled(odev, value);
@@ -217,7 +217,7 @@ static ssize_t class_set_enabled(struct device
*device,
(struct asus_oled_dev *) dev_get_drvdata(device);
unsigned long value;

- if (strict_strtoul(buf, 10, &value))
+ if (kstrtoul(buf, 10, &value))
return -EINVAL;

enable_oled(odev, value);
-- 
1.7.6.4




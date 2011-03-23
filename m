Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab1CWMy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:54:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42356 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab1CWMyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=r3vOmd1Q5BfjtSrNrw8ZYpwmc+mFnWasxQ/FsebXkcNRju5e/tylMIGv57Vrgcxecq
         5N8aKzRYw4qNHMWeuw8LgB/z8JRm8Jg+6Ejb4BadRuqxV7CsQahryXezjd8MdRrx9mgq
         gHsi7lM9SS5Stbi/no08/EZG+ed8vGUgM+W5A=
Subject: [PATCH] mfd: Constify i2c_device_id tables
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@openmoko.org>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 20:54:17 +0800
Message-ID: <1300884857.3015.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Harald Welte <laforge@openmoko.org>
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/mfd/pcf50633-core.c |    2 +-
 drivers/mfd/wl1273-core.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index c1306ed..c7687f6 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -356,7 +356,7 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id pcf50633_id_table[] = {
+static const struct i2c_device_id pcf50633_id_table[] = {
 	{"pcf50633", 0x73},
 	{/* end of list */}
 };
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index f76f6c7..04914f2 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -25,7 +25,7 @@
 
 #define DRIVER_DESC "WL1273 FM Radio Core"
 
-static struct i2c_device_id wl1273_driver_id_table[] = {
+static const struct i2c_device_id wl1273_driver_id_table[] = {
 	{ WL1273_FM_DRIVER_NAME, 0 },
 	{ }
 };
-- 
1.7.1




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0CUPqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 11:46:16 -0400
Received: from vps.mortis.eu ([79.99.135.181]:35892 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0CUPqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 11:46:13 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Giel van Schijndel <me@mortis.eu>,
       Jonathan Cameron <jic23@cam.ac.uk>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Hwmon: f71882fg: fixed braces coding style issues
Date: Sun, 21 Mar 2010 16:37:13 +0100
Message-Id: <1269185834-10266-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several coding style issues.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index a95fa42..21bc661 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -866,11 +866,11 @@ static int superio_inw(int base, int reg)
 static inline void superio_enter(int base)
 {
 	/* according to the datasheet the key must be send twice! */
-	outb( SIO_UNLOCK_KEY, base);
-	outb( SIO_UNLOCK_KEY, base);
+	outb(SIO_UNLOCK_KEY, base);
+	outb(SIO_UNLOCK_KEY, base);
 }
 
-static inline void superio_select( int base, int ld)
+static inline void superio_select(int base, int ld)
 {
 	outb(SIO_REG_LDSEL, base);
 	outb(ld, base + 1);
@@ -945,7 +945,7 @@ static struct f71882fg_data *f71882fg_update_device(struct device *dev)
 	mutex_lock(&data->update_lock);
 
 	/* Update once every 60 seconds */
-	if ( time_after(jiffies, data->last_limits + 60 * HZ ) ||
+	if (time_after(jiffies, data->last_limits + 60 * HZ) ||
 			!data->valid) {
 		if (data->type == f71882fg || data->type == f71889fg) {
 			data->in1_max =
@@ -2151,8 +2151,7 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
 	}
 
 	*address = superio_inw(sioaddr, SIO_REG_ADDR);
-	if (*address == 0)
-	{
+	if (*address == 0) {
 		printk(KERN_WARNING DRVNAME ": Base address not set\n");
 		goto exit;
 	}
-- 
1.6.4.4


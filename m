Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2EAGZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:25:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53700 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2EAGZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:25:48 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 4/5] Staging: comedi: Checkpatch cleanups.
Date: Tue,  1 May 2012 11:55:09 +0530
Message-Id: <1335853510-29545-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/dt9812.c:369: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:369: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:395: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:396: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:434: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:480: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:556: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/dt9812.c:623: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt9812.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 21d94ed..8113cfb 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -366,7 +366,7 @@ static int dt9812_read_info(struct usb_dt9812 *dev, int offset, void *buf,
 }
 
 static int dt9812_read_multiple_registers(struct usb_dt9812 *dev, int reg_count,
-					  u8 * address, u8 * value)
+					  u8 *address, u8 *value)
 {
 	struct dt9812_usb_cmd cmd;
 	int i, count, retval;
@@ -392,8 +392,8 @@ static int dt9812_read_multiple_registers(struct usb_dt9812 *dev, int reg_count,
 }
 
 static int dt9812_write_multiple_registers(struct usb_dt9812 *dev,
-					   int reg_count, u8 * address,
-					   u8 * value)
+					   int reg_count, u8 *address,
+					   u8 *value)
 {
 	struct dt9812_usb_cmd cmd;
 	int i, count, retval;
@@ -431,7 +431,7 @@ static int dt9812_rmw_multiple_registers(struct usb_dt9812 *dev, int reg_count,
 	return retval;
 }
 
-static int dt9812_digital_in(struct slot_dt9812 *slot, u8 * bits)
+static int dt9812_digital_in(struct slot_dt9812 *slot, u8 *bits)
 {
 	int result = -ENODEV;
 
@@ -477,7 +477,7 @@ static int dt9812_digital_out(struct slot_dt9812 *slot, u8 bits)
 	return result;
 }
 
-static int dt9812_digital_out_shadow(struct slot_dt9812 *slot, u8 * bits)
+static int dt9812_digital_out_shadow(struct slot_dt9812 *slot, u8 *bits)
 {
 	int result = -ENODEV;
 
@@ -553,7 +553,7 @@ static void dt9812_configure_gain(struct usb_dt9812 *dev,
 	}
 }
 
-static int dt9812_analog_in(struct slot_dt9812 *slot, int channel, u16 * value,
+static int dt9812_analog_in(struct slot_dt9812 *slot, int channel, u16 *value,
 			    enum dt9812_gain gain)
 {
 	struct dt9812_rmw_byte rmw[3];
@@ -620,7 +620,7 @@ exit:
 }
 
 static int dt9812_analog_out_shadow(struct slot_dt9812 *slot, int channel,
-				    u16 * value)
+				    u16 *value)
 {
 	int result = -ENODEV;
 
-- 
1.7.0.4


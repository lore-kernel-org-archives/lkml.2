Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1GHO7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:59:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1GHO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:59:44 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 6/6] Staging: comedi: fix warning issue in dt9812.c
Date: Fri,  8 Jul 2011 20:42:08 +0530
Message-Id: <1310137928-6942-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix warning issue in dt9812.c>
References: <[PATCH]Staging: comedi: fix warning issue in dt9812.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the dt9812.c file that fixes up a  warning:please no space at the start and error:"foo * bar"should be "foo *bar" found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/dt9812.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 32d9c42..6629622 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -196,7 +196,7 @@ struct dt9812_flash_data {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_RDS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
+((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
 
 struct dt9812_read_multi {
 	u8 count;
@@ -209,8 +209,8 @@ struct dt9812_write_byte {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_WRTS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
-      sizeof(struct dt9812_write_byte))
+((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
+sizeof(struct dt9812_write_byte))
 
 struct dt9812_write_multi {
 	u8 count;
@@ -224,7 +224,7 @@ struct dt9812_rmw_byte {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_RMWS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(struct dt9812_rmw_byte))
+((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(struct dt9812_rmw_byte))
 
 struct dt9812_rmw_multi {
 	u8 count;
@@ -365,7 +365,7 @@ static int dt9812_read_info(struct usb_dt9812 *dev, int offset, void *buf,
 }
 
 static int dt9812_read_multiple_registers(struct usb_dt9812 *dev, int reg_count,
-					  u8 * address, u8 * value)
+					  u8 *address, u8 *value)
 {
 	struct dt9812_usb_cmd cmd;
 	int i, count, retval;
@@ -391,8 +391,8 @@ static int dt9812_read_multiple_registers(struct usb_dt9812 *dev, int reg_count,
 }
 
 static int dt9812_write_multiple_registers(struct usb_dt9812 *dev,
-					   int reg_count, u8 * address,
-					   u8 * value)
+					   int reg_count, u8 *address,
+					   u8 *value)
 {
 	struct dt9812_usb_cmd cmd;
 	int i, count, retval;
@@ -619,7 +619,7 @@ exit:
 }
 
 static int dt9812_analog_out_shadow(struct slot_dt9812 *slot, int channel,
-				    u16 * value)
+				    u16 *value)
 {
 	int result = -ENODEV;
 
-- 
1.6.5.2


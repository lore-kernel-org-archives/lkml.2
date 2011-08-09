Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab1HINg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:36:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43897 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1HINg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:36:57 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix error issue in dt9812.c
Date: Tue,  9 Aug 2011 19:21:21 +0530
Message-Id: <1312897881-17433-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix error issue in dt9812.c>
References: <[PATCH]Staging: comedi: fix error issue in dt9812.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the dt9812.c file that fixes up a error: "foo * bar" should be "foo *bar" found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/dt9812.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 32d9c42..e50f5df 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
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


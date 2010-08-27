Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0H0AVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:21:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42820 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0H0AVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ocsyBqzZ00af+zPxWjhOqqbSK7nBZduw5udrhD+BBN4VJaWPBgjEeh/yfrOy2pbXNR
         V+JmBMNkvLUTxviKyznsO7t83YKRv9nJGv5zGmCog1JPPh1r9uAXcW+WW5Ro5Al89hzP
         e8hsCdkViRFT4DpA314ML8TNNlGqFj3Kep2cI=
MIME-Version: 1.0
Date: Fri, 27 Aug 2010 09:21:43 +0900
Message-ID: <AANLkTinehvNybMS=r=c+KJO5zGD9UBodMtA+jFAEj55K@mail.gmail.com>
Subject: [PATCH] hp_accel: Add HP Mini 510x family support
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, eric.piel@tremplin-utc.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an enhanced version of Takashi Iwai's
[PATCH] hp_accel: Add quirks for HP ProBook 532x and HP Mini 5102
My HP Mini 5101 works fine with this patch.
Confirmed with Tux Racer.

Signed-off by: Masanari Iida <standby24x7@gmail.com>

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 36e9575..c5cd3db 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -222,7 +222,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
 	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
-	AXIS_DMI_MATCH("Mini5102", "HP Mini 5102", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"

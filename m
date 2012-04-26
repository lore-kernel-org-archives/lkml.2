Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2DZIbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:31:20 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:39259 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2DZIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:31:17 -0400
From: puzzleduck@gmail.com
To: wgreathouse@smva.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH] USB: serial: Changes to conform with coding style
Date: Thu, 26 Apr 2012 19:31:04 +1000
Message-Id: <1335432664-4587-1-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: PuZZleDucK <puzzleduck@gmail.com>

Removed some spaces before tabs and reformatted switch statement.

Signed-off-by: PuZZleDucK <puzzleduck@gmail.com>
---
 drivers/usb/serial/belkin_sa.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index a52e0d2..35b0d3d 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -2,17 +2,17 @@
  * Belkin USB Serial Adapter Driver
  *
  *  Copyright (C) 2000		William Greathouse (wgreathouse@smva.com)
- *  Copyright (C) 2000-2001 	Greg Kroah-Hartman (greg@kroah.com)
+ *  Copyright (C) 2000-2001	Greg Kroah-Hartman (greg@kroah.com)
  *  Copyright (C) 2010		Johan Hovold (jhovold@gmail.com)
  *
  *  This program is largely derived from work by the linux-usb group
  *  and associated source files.  Please see the usb/serial files for
  *  individual credits and copyrights.
  *
- * 	This program is free software; you can redistribute it and/or modify
- * 	it under the terms of the GNU General Public License as published by
- * 	the Free Software Foundation; either version 2 of the License, or
- * 	(at your option) any later version.
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
  *
  * See Documentation/usb/usb-serial.txt for more information on using this
  * driver
@@ -403,7 +403,8 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 		case CS8:
 			urb_value = BELKIN_SA_DATA_BITS(8);
 			break;
-		default: dbg("CSIZE was not CS5-CS8, using default of 8");
+		default:
+			dbg("CSIZE was not CS5-CS8, using default of 8");
 			urb_value = BELKIN_SA_DATA_BITS(8);
 			break;
 		}
-- 
1.7.2.5


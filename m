Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab0JFBE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:04:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261Ab0JFBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xEcKEVUB04tUUbwOVmqi7nyuaD7hyBrd9QSPIzil6juoGqBaupV4kfgrz8YjgvZEvV
         ViBh+0O20I6fZubGSBAvZiKy/5dnN69Q7CM+VvgVKHisoLFJTyoEUCiYIsPWVrAW06/4
         YVVi6mVFto5VBRC9DQRuza1sBumDQjgBQi+n8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 12/28] Staging: comedi: drivers: 8255.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:27 -0400
Message-Id: <1286326843-6170-12-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. All warnings were
WARNING: please, no space for starting a line.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/8255.c |   78 ++++++++++++++++----------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 95049a8..beefc10 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -1,23 +1,23 @@
 /*
-    comedi/drivers/8255.c
-    Driver for 8255
+	comedi/drivers/8255.c
+	Driver for 8255
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1998 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 1998 David A. Schleef <ds@schleef.org>
 
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
 */
 /*
@@ -45,7 +45,7 @@ multiple 8255 chips.  To configure the driver for such a card, the
 option list should be a list of the I/O port bases for each of the
 8255 chips.  For example,
 
-  comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
+	comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
 
 Note that most PCI 8255 boards do NOT work with this driver, and
 need a separate driver as a wrapper.  For those that do work, the
@@ -54,28 +54,28 @@ I/O port base address can be found in the output of 'lspci -v'.
 */
 
 /*
-   This file contains an exported subdevice for driving an 8255.
-
-   To use this subdevice as part of another driver, you need to
-   set up the subdevice in the attach function of the driver by
-   calling:
-
-     subdev_8255_init(device, subdevice, callback_function, arg)
-
-   device and subdevice are pointers to the device and subdevice
-   structures.  callback_function will be called to provide the
-   low-level input/output to the device, i.e., actual register
-   access.  callback_function will be called with the value of arg
-   as the last parameter.  If the 8255 device is mapped as 4
-   consecutive I/O ports, you can use NULL for callback_function
-   and the I/O port base for arg, and an internal function will
-   handle the register access.
-
-   In addition, if the main driver handles interrupts, you can
-   enable commands on the subdevice by calling subdev_8255_init_irq()
-   instead.  Then, when you get an interrupt that is likely to be
-   from the 8255, you should call subdev_8255_interrupt(), which
-   will copy the latched value to a Comedi buffer.
+	This file contains an exported subdevice for driving an 8255.
+
+	To use this subdevice as part of another driver, you need to
+	set up the subdevice in the attach function of the driver by
+	calling:
+
+		subdev_8255_init(device, subdevice, callback_function, arg)
+
+	device and subdevice are pointers to the device and subdevice
+	structures.  callback_function will be called to provide the
+	low-level input/output to the device, i.e., actual register
+	access.  callback_function will be called with the value of arg
+	as the last parameter.  If the 8255 device is mapped as 4
+	consecutive I/O ports, you can use NULL for callback_function
+	and the I/O port base for arg, and an internal function will
+	handle the register access.
+
+	In addition, if the main driver handles interrupts, you can
+	enable commands on the subdevice by calling subdev_8255_init_irq()
+	instead.  Then, when you get an interrupt that is likely to be
+	from the 8255, you should call subdev_8255_interrupt(), which
+	will copy the latched value to a Comedi buffer.
  */
 
 #include "../comedidev.h"
@@ -396,7 +396,7 @@ EXPORT_SYMBOL(subdev_8255_cleanup);
 
 /*
 
-   Start of the 8255 standalone device
+	Start of the 8255 standalone device
 
  */
 
-- 
1.7.3.1.50.g1e633


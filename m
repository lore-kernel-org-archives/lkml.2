Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab0JFBBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0JFBBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KhgQePIg+ufb4bKyHSdaECXIoF0qLYMltLOe3a3yh9ViyDEGeWASn/dX9ZSv5LvIUk
         hrKKNz2+/tBTIWqPhw05hbbfVxWJfSxAX5iB7uQ3OYxWENc7MfzsxB4tJagqymp5PlTD
         orWfQ4VTMWekiFeRazmrnrRGW1tADkec6cZVU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 05/28] Staging: comedi: comedi_fops.c: Edit file so that checkpatch.pl has 1 warnings and 0 errors
Date: Tue,  5 Oct 2010 21:00:20 -0400
Message-Id: <1286326843-6170-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. Could not get ever error but
I got it down to to just one, WARNING: externs should be avoided in .c files.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |   52 +++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 1409131..f2ef310 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1,23 +1,23 @@
 /*
-    comedi/comedi_fops.c
-    comedi kernel module
+	comedi/comedi_fops.c
+	comedi kernel module
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
 
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
 
@@ -549,20 +549,20 @@ static int do_chaninfo_ioctl(struct comedi_device *dev,
 	return 0;
 }
 
- /*
-    COMEDI_BUFINFO
-    buffer information ioctl
+/*
+	COMEDI_BUFINFO
+	buffer information ioctl
 
-    arg:
-    pointer to bufinfo structure
+	arg:
+	pointer to bufinfo structure
 
-    reads:
-    bufinfo at arg
+	reads:
+	bufinfo at arg
 
-    writes:
-    modified bufinfo at arg
+	writes:
+	modified bufinfo at arg
 
-  */
+*/
 static int do_bufinfo_ioctl(struct comedi_device *dev,
 			    struct comedi_bufinfo __user *arg, void *file)
 {
@@ -1764,7 +1764,7 @@ done:
 }
 
 /*
-   This function restores a subdevice to an idle state.
+	This function restores a subdevice to an idle state.
  */
 void do_become_nonbusy(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-- 
1.7.3.1.50.g1e633


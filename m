Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab0JFBB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab0JFBBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e5wzVc55czIiPZq1EreiAaW9yKQh1ERy6RSb/CwpbcJux4JQYiWjN+1P3iMvKQsvPf
         Djtc/sb5TW6J+VDmOsMETZsPxuUfZjwR+uwqhkscl/wsB4GH1EM8bqHQkcICuc4vqMK3
         VQ0evpjD6iVs/kAZ5LXY1X/1Cd5Bu35nfm00s=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 26/28] Staging: comedi: drivers: aio_iiro_16.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:41 -0400
Message-Id: <1286326843-6170-26-git-send-email-tdent48227@gmail.com>
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
 drivers/staging/comedi/drivers/aio_iiro_16.c |   32 +++++++++++++-------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 4875995..d0b9800 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -1,23 +1,23 @@
 /*
 
-    comedi/drivers/aio_iiro_16.c
+	comedi/drivers/aio_iiro_16.c
 
-    Driver for Acces I/O Products PC-104 AIO-IIRO-16 Digital I/O board
-    Copyright (C) 2006 C&C Technologies, Inc.
+	Driver for Acces I/O Products PC-104 AIO-IIRO-16 Digital I/O board
+	Copyright (C) 2006 C&C Technologies, Inc.
 
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
@@ -26,11 +26,11 @@ Driver: aio_iiro_16
 Description: Acces I/O Products PC-104 IIRO16 Relay And Isolated Input Board
 Author: Zachary Ware <zach.ware@cctechnol.com>
 Devices:
- [Acces I/O] PC-104 AIO12-8
+	[Acces I/O] PC-104 AIO12-8
 Status: experimental
 
 Configuration Options:
-  [0] - I/O port base address
+	[0] - I/O port base address
 
 */
 
-- 
1.7.3.1.50.g1e633


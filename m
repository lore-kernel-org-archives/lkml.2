Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab0JFBDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:03:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242Ab0JFBBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XwZyTxgORSTHIRhqljTpHDRI7wbjRZAPV8Q4E9eOlPPFwJp0tjvevrTk7gCfG4KhGb
         Nske6JY2xGFVjAUKdOdufh1akjXLAm5Br6em3q1zMtqYJjQGSPcmdgx0bdJboUS1Lm5/
         0+Cq6kIwRPqhOXQlkh8nEf5l83imMCN7p7lIY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 16/28] Staging: comedi: drivers: adl_pci7296.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:31 -0400
Message-Id: <1286326843-6170-16-git-send-email-tdent48227@gmail.com>
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
 drivers/staging/comedi/drivers/adl_pci7296.c |   36 +++++++++++++-------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index f28fe6b..b03a8ff 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -1,22 +1,22 @@
 /*
-    comedi/drivers/adl_pci7296.c
+	comedi/drivers/adl_pci7296.c
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 2000 David A. Schleef <ds@schleef.org>
 
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
@@ -28,10 +28,10 @@ Updated: Mon, 14 Apr 2008 15:05:56 +0100
 Status: testing
 
 Configuration Options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first supported
-  PCI device found will be used.
+	[0] - PCI bus of device (optional)
+	[1] - PCI slot of device (optional)
+	If bus/slot is not specified, the first supported
+	PCI device found will be used.
 */
 
 #include "../comedidev.h"
-- 
1.7.3.1.50.g1e633


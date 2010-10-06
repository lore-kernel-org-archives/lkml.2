Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab0JFBEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:04:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab0JFBBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WvLC4Z2JjLRnblJdzozKS6wjBXNH1hq9JJFMEVUYFKwUQtNTQanFb94TQt2CpqebYh
         JNS6YmSh6iJLlUoZuK1/cp675K8WxZe7Y1p5W8wcbfZlTpysj+NnlkFp38Yp19vshEx9
         aLiKG1VRgYg6W4NW4lQFp0rZTPtSdkYTxv2QU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 14/28] Staging: comedi: drivers: adl_pci2608.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:29 -0400
Message-Id: <1286326843-6170-14-git-send-email-tdent48227@gmail.com>
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
 drivers/staging/comedi/drivers/adl_pci6208.c |   42 +++++++++++++-------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 073d024..8c8c691 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -1,29 +1,29 @@
 /*
-    comedi/drivers/adl_pci6208.c
-
-    Hardware driver for ADLink 6208 series cards:
-	card	     | voltage output    | current output
-	-------------+-------------------+---------------
-	PCI-6208V    |  8 channels       | -
-	PCI-6216V    | 16 channels       | -
-	PCI-6208A    |  8 channels       | 8 channels
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+	comedi/drivers/adl_pci6208.c
+
+	Hardware driver for ADLink 6208 series cards:
+		card	     | voltage output    | current output
+		-------------+-------------------+---------------
+		PCI-6208V    |  8 channels       | -
+		PCI-6216V    | 16 channels       | -
+		PCI-6208A    |  8 channels       | 8 channels
+
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 /*
 Driver: adl_pci6208
@@ -34,7 +34,7 @@ Updated: Fri, 30 Jan 2004 14:44:27 +0800
 Status: untested
 
 Configuration Options:
-  none
+	none
 
 References:
 	- ni_660x.c
-- 
1.7.3.1.50.g1e633


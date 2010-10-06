Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab0JFBBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280Ab0JFBBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pQH4rSjqgJ5ZGIHTBOA9ON86sVYP0EPgkxNtBRnfJSei2WJcxB7PQGiFjYRt88wjxK
         gAH20EfVtdnWjfUpNOcDpRUiLcTw5vPcMVfE+IC1kafyj0DfWrvyI+2EpLJ7oFYQ39gU
         YXjd3EYeWYXU9pl0uXaC6IK58TMLABpPxM+LY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 15/28] Staging: comedi: drivers: adl_pci7230.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:30 -0400
Message-Id: <1286326843-6170-15-git-send-email-tdent48227@gmail.com>
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
 drivers/staging/comedi/drivers/adl_pci7230.c |   36 +++++++++++++-------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 72a7258..afc26bb 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -1,22 +1,22 @@
 /*
-    comedi/drivers/adl_pci7230.c
+	comedi/drivers/adl_pci7230.c
 
-    Hardware comedi driver fot PCI7230 Adlink card
-    Copyright (C) 2010 David Fernandez <dfcastelao@gmail.com>
+	Hardware comedi driver fot PCI7230 Adlink card
+	Copyright (C) 2010 David Fernandez <dfcastelao@gmail.com>
 
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
@@ -28,10 +28,10 @@ Status: experimental
 Updated: Mon, 14 Apr 2008 15:08:14 +0100
 
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


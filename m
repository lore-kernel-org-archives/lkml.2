Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1CVBKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:10:17 -0400
Received: from umbout1.umaryland.edu ([134.192.184.201]:13642 "EHLO
	umbout1.umaryland.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1CVBKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:10:15 -0400
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 21:10:15 EDT
X-IronPort-AV: E=Sophos;i="4.63,222,1299474000"; 
   d="scan'208";a="220099354"
From: Ronald Kasl <rkasl@computer.org>
To: gregkh@suse.de, arun.thomas@gmail.com
Cc: darren.armstrong85@gmail.com, mithlesh@linsyssoft.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ronald Kasl <rkasl@computer.org>
Subject: [PATCH 1/1] Staging: comedi: fix coding style / spaces
Date: Mon, 13 Sep 2010 16:31:01 -0400
Message-Id: <1284409861-3446-1-git-send-email-rkasl@computer.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ssv_dnp.c file that fixes up the extra space warning
found by the checkpatch.pl tool

Signed-off-by: Ronald Kasl <rkasl@computer.org>
---
 drivers/staging/comedi/drivers/ssv_dnp.c |   40 +++++++++++++++---------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 526de2e..cb72436 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -1,24 +1,24 @@
 /*
-    comedi/drivers/ssv_dnp.c
-    generic comedi driver for SSV Embedded Systems' DIL/Net-PCs
-    Copyright (C) 2001 Robert Schwebel <robert@schwebel.de>
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
+comedi/drivers/ssv_dnp.c
+generic comedi driver for SSV Embedded Systems' DIL/Net-PCs
+Copyright (C) 2001 Robert Schwebel <robert@schwebel.de>
+
+COMEDI - Linux Control and Measurement Device Interface
+Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+
+This program is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
+
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program; if not, write to the Free Software
+Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
 */
 /*
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab0JFBEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:04:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273Ab0JFBBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t0UqZtEdekz9kLwgCrTlzxITWo3gkNc192Zab6ytWbvwPLOHl0RJ1yaH0ZirWn7fMs
         R7HdSagF+Tgm5lFYMjArXvqzbQ5629ZopRXFsm+f7zRzxeS0lNpKOBH+qIzOrM3Zkyn0
         QDUiAOamebvd3iDVfM467IRV9/nnT3IIg69Ek=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 10/28] Staging: comedi: kcomedilib: kcomedilib_main.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:25 -0400
Message-Id: <1286326843-6170-10-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. All warnings were
WARNING: please, no space for starting a line and
WARNING: consider using strict_strtoul in preference to simple_strtoul.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |   32 ++++++++++----------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 0252b44..dd8d8a4 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -1,23 +1,23 @@
 /*
-    kcomedilib/kcomedilib.c
-    a comedlib interface for kernel modules
+	kcomedilib/kcomedilib.c
+	a comedlib interface for kernel modules
 
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
 
@@ -50,7 +50,7 @@ struct comedi_device *comedi_open(const char *filename)
 	if (strncmp(filename, "/dev/comedi", 11) != 0)
 		return NULL;
 
-	minor = simple_strtoul(filename + 11, NULL, 0);
+	minor = strict_strtoul(filename + 11, NULL, 0);
 
 	if (minor >= COMEDI_NUM_BOARD_MINORS)
 		return NULL;
-- 
1.7.3.1.50.g1e633

